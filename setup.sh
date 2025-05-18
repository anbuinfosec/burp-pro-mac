#!/bin/bash

APP_DIR="/Applications/Burp Suite Professional.app"
RESOURCE_DIR="$APP_DIR/Contents/Resources"
APP_DIR_PATH="$RESOURCE_DIR/app"
VM_OPTIONS_FILE="$APP_DIR/Contents/vmoptions.txt"
KEYGEN_JAR="BurpLoaderKeygen.jar"
DOWNLOAD_URL="https://github.com/anbuinfosec/burp-pro-mac/releases/download/Letest/BurpLoaderKeygen.jar"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

function display_help() {
    echo -e "${BLUE}[INFO] Developer: @anbuinfosec${NC}"
    echo -e "${BLUE}[INFO] GitHub: https://github.com/anbuinfosec/burp-pro-mac${NC}"
    echo -e "${BLUE}[INFO] Usage:${NC}"
    echo -e "  ${GREEN}[CMD] burp.sh -setup${NC}  : Set up Burp Suite Professional"
    echo -e "  ${GREEN}[CMD] burp.sh -fix${NC}    : Fix quarantine issues"
    echo -e "  ${GREEN}[CMD] burp.sh -run${NC}    : Run the registration machine"
    echo -e "  ${GREEN}[CMD] burp.sh -help${NC}   : Show this help menu"
}

function install_homebrew() {
    echo -e "${YELLOW}[WARN] Checking Homebrew...${NC}"
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}[WARN] Homebrew not found. Installing...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            echo -e "${RED}[ERR] Failed to install Homebrew. Exiting.${NC}"
            exit 1
        }
        echo -e "${GREEN}[OK] Homebrew installed successfully.${NC}"
        export PATH="/opt/homebrew/bin:$PATH"
    else
        echo -e "${GREEN}[OK] Homebrew is already installed.${NC}"
    fi
}

function install_java() {
    echo -e "${YELLOW}[WARN] Checking Java...${NC}"
    if ! command -v java &> /dev/null; then
        echo -e "${YELLOW}[WARN] Java not found. Installing OpenJDK...${NC}"
        install_homebrew
        brew install openjdk || {
            echo -e "${RED}[ERR] Failed to install Java. Exiting.${NC}"
            exit 1
        }
        echo -e "${GREEN}[OK] Java installed successfully.${NC}"
        sudo ln -sfn $(brew --prefix openjdk)/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
        export PATH="$(/usr/libexec/java_home)/bin:$PATH"
    else
        echo -e "${GREEN}[OK] Java is already installed.${NC}"
    fi
}

function setup_burp_suite() {
    install_java

    if [[ ! -d "$APP_DIR" ]]; then
        echo -e "${RED}[ERR] Burp Suite Professional not found at $APP_DIR. Please ensure it is installed.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}[WARN] Ensuring app directory exists...${NC}"
    mkdir -p "$APP_DIR_PATH"
    cd "$APP_DIR_PATH" || {
        echo -e "${RED}[ERR] Failed to navigate to $APP_DIR_PATH. Exiting.${NC}"
        exit 1
    }

    if [[ ! -f "$KEYGEN_JAR" ]]; then
        echo -e "${YELLOW}[WARN] Downloading $KEYGEN_JAR...${NC}"
        curl -L -o "$KEYGEN_JAR" "$DOWNLOAD_URL" || {
            echo -e "${RED}[ERR] Failed to download $KEYGEN_JAR from $DOWNLOAD_URL. Exiting.${NC}"
            exit 1
        }
        echo -e "${GREEN}[OK] $KEYGEN_JAR downloaded successfully.${NC}"
    else
        echo -e "${BLUE}[INFO] $KEYGEN_JAR already exists. Skipping download.${NC}"
    fi

    echo -e "${YELLOW}[WARN] Starting the registration machine...${NC}"
    "$RESOURCE_DIR/jre.bundle/Contents/Home/bin/java" -jar "$KEYGEN_JAR" || {
        echo -e "${RED}[ERR] Failed to start BurpLoaderKeygen. Ensure $KEYGEN_JAR is in the correct directory.${NC}"
        exit 1
    }

    echo -e "${YELLOW}[WARN] Modifying configuration file...${NC}"
    if [[ -f "$VM_OPTIONS_FILE" ]]; then
        {
            echo "--add-opens=java.base/java.lang=ALL-UNNAMED"
            echo "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED"
            echo "--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED"
            echo "--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED"
            echo "-javaagent:$KEYGEN_JAR"
            echo "-noverify"
        } >> "$VM_OPTIONS_FILE"
        echo -e "${GREEN}[OK] Configuration updated successfully.${NC}"
    else
        echo -e "${RED}[ERR] Configuration file not found at $VM_OPTIONS_FILE. Exiting.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[OK] Setup completed successfully!${NC}"
}

function fix_quarantine() {
    echo -e "${YELLOW}[WARN] Fixing 'damaged and can't be opened' error...${NC}"
    sudo xattr -r -d com.apple.quarantine "$APP_DIR" || {
        echo -e "${RED}[ERR] Failed to remove quarantine attribute. You might need to run this script with sudo.${NC}"
        exit 1
    }
    echo -e "${GREEN}[OK] Quarantine fix applied successfully!${NC}"
}

function run_burp() {
    if [[ ! -d "$APP_DIR_PATH" ]]; then
        echo -e "${RED}[ERR] Directory $APP_DIR_PATH does not exist. Please run setup first.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}[WARN] Changing directory to $APP_DIR_PATH...${NC}"
    cd "$APP_DIR_PATH" || {
        echo -e "${RED}[ERR] Failed to navigate to $APP_DIR_PATH. Exiting.${NC}"
        exit 1
    }
    if [[ ! -f "$KEYGEN_JAR" ]]; then
        echo -e "${RED}[ERR] $KEYGEN_JAR not found in $APP_DIR_PATH. Please run setup first.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}[CMD] Running the registration machine...${NC}"
    "$RESOURCE_DIR/jre.bundle/Contents/Home/bin/java" -jar "$KEYGEN_JAR"
}

case "$1" in
    -setup)
        setup_burp_suite
        ;;
    -fix)
        fix_quarantine
        ;;
    -run)
        run_burp
        ;;
    -help | *)
        display_help
        ;;
esac
