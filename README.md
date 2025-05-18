<p align="center">
  <img src="https://portswigger.net/public/portswigger-logo.svg" alt="PortSwigger Logo" width="200" />
</p>

<h1 align="center">Burp-Pro Mac</h1>

---

# Burp Suite Professional Setup Script for macOS

This script automates the installation, setup, and configuration of **Burp Suite Professional** on macOS. It handles downloading the necessary keygen, modifying JVM options, and fixing common macOS-specific issues to ensure Burp Suite runs smoothly.

---

## 🚀 Developer Information

- **Developer**: [@anbuinfosec](https://github.com/anbuinfosec)  
- **GitHub Repository**: [Burp Suite Pro Mac](https://github.com/anbuinfosec/burp-pro-mac)  

---

## 📝 Prerequisites

### 1. Download Burp Suite Professional

Download the latest version from the official website:  
[https://portswigger.net/burp/pro](https://portswigger.net/burp/pro)  

Install the app to the default directory:

```plaintext
/Applications/Burp Suite Professional.app
````

---

### 2. Clone this Repository

Get the setup script from GitHub:

```bash
git clone https://github.com/anbuinfosec/burp-pro-mac.git
cd burp-pro-mac
```

---

### 3. Make the Script Executable

```bash
chmod +x burp.sh
```

---

## ⚙️ Usage

Run the script with any of the following options:

| Option   | Description                                             |
| -------- | ------------------------------------------------------- |
| `-setup` | Setup Burp Suite Professional (download keygen, config) |
| `-fix`   | Fix macOS quarantine issues causing app damage errors   |
| `-run`   | Launch the BurpLoaderKeygen registration machine        |
| `-help`  | Show help and usage information                         |

---

### Example Commands

```bash
sudo ./burp.sh -setup
sudo ./burp.sh -fix
./burp.sh -run
./burp.sh -help
```

---

## 🔍 What the Script Does

* **Homebrew & Java Check**
  Verifies if Homebrew and Java (OpenJDK) are installed.
  If missing, it automatically installs them for you.

* **Keygen Download**
  Downloads `BurpLoaderKeygen.jar` to the Burp Suite resources directory if not already present.

* **JVM Configuration**
  Appends JVM flags in `vmoptions.txt` to allow Burp Suite to run with the keygen agent.

* **Quarantine Fix**
  Removes the macOS quarantine attribute to fix `"damaged and can't be opened"` errors.

* **Run Registration Machine**
  Starts the BurpLoaderKeygen jar to register Burp Suite.

---

## 🔗 Download Location for Keygen

The keygen is automatically downloaded from the following release URL:

[BurpLoaderKeygen.jar](https://github.com/anbuinfosec/burp-pro-mac/releases/download/Letest/BurpLoaderKeygen.jar)

---

## 📌 Important Notes

* This script assumes Burp Suite Professional is installed in `/Applications/Burp Suite Professional.app`.
* Running with `sudo` may be required to modify application files and remove quarantine attributes.
* The script is tested on macOS only.
* Java installation via Homebrew is targeted to the latest OpenJDK version.
* JVM options appended to `vmoptions.txt` are necessary for Burp Suite to load the keygen agent.