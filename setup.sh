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
    echo -e "${BLUE}Developer: @anbuinfosec${NC}"
    echo -e "${BLUE}GitHub: https://github.com/anbuinfosec/burp-pro-mac${NC}"
    echo -e "${BLUE}Usage:${NC}"
    echo -e "  ${GREEN}setup.sh -setup${NC}  : Set up Burp Suite Professional"
    echo -e "  ${GREEN}setup.sh -fix${NC}    : Fix quarantine issues"
    echo -e "  ${GREEN}setup.sh -help${NC}   : Show this help menu"
}

function setup_burp_suite() {
    if [[ ! -d "$APP_DIR" ]]; then
        echo -e "${RED}Burp Suite Professional not found at $APP_DIR. Please ensure it is installed.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Ensuring app directory exists...${NC}"
    mkdir -p "$APP_DIR_PATH"
    cd "$APP_DIR_PATH" || { echo -e "${RED}Failed to navigate to $APP_DIR_PATH. Exiting.${NC}"; exit 1; }
    if [[ ! -f "$KEYGEN_JAR" ]]; then
        echo -e "${YELLOW}Downloading $KEYGEN_JAR...${NC}"
        curl -L -o "$KEYGEN_JAR" "$DOWNLOAD_URL" || {
            echo -e "${RED}Failed to download $KEYGEN_JAR from $DOWNLOAD_URL. Exiting.${NC}"
            exit 1
        }
        echo -e "${GREEN}$KEYGEN_JAR downloaded successfully.${NC}"
    else
        echo -e "${BLUE}$KEYGEN_JAR already exists. Skipping download.${NC}"
    fi
    echo -e "${YELLOW}Starting the registration machine...${NC}"
    "$RESOURCE_DIR/jre.bundle/Contents/Home/bin/java" -jar "$KEYGEN_JAR" || {
        echo -e "${RED}Failed to start BurpLoaderKeygen. Ensure $KEYGEN_JAR is in the correct directory.${NC}"
        exit 1
    }
    echo -e "${YELLOW}Modifying configuration file...${NC}"
    if [[ -f "$VM_OPTIONS_FILE" ]]; then
        {
            echo "--add-opens=java.base/java.lang=ALL-UNNAMED"
            echo "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED"
            echo "--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED"
            echo "--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED"
            echo "-javaagent:$KEYGEN_JAR"
            echo "-noverify"
        } >> "$VM_OPTIONS_FILE"
        echo -e "${GREEN}Configuration updated successfully.${NC}"
    else
        echo -e "${RED}Configuration file not found at $VM_OPTIONS_FILE. Exiting.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Setup completed successfully!${NC}"
}

function fix_quarantine() {
    echo -e "${YELLOW}Fixing 'damaged and can't be opened' error...${NC}"
    sudo xattr -r -d com.apple.quarantine "$APP_DIR" || {
        echo -e "${RED}Failed to remove quarantine attribute. You might need to run this script with sudo.${NC}"
        exit 1
    }
    echo -e "${GREEN}Quarantine fix applied successfully!${NC}"
}

case "$1" in
    -setup)
        setup_burp_suite
        ;;
    -fix)
        fix_quarantine
        ;;
    -help | *)
        display_help
        ;;
esac
