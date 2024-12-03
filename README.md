# Burp Suite Professional Setup Script

This script automates the setup and configuration of **Burp Suite Professional** on macOS, including downloading necessary resources and fixing common issues.

## Developer Information

- **Developer**: [@anbuinfosec](https://github.com/anbuinfosec)
- **GitHub Repository**: [Burp Suite Pro Mac](https://github.com/anbuinfosec/burp-pro-mac)

---

## Prerequisites

### 1. Download Burp Suite Professional
Visit the [official Burp Suite Professional website](https://portswigger.net/burp/pro) to download the application. Install it in the default location:
```plaintext
/Applications/Burp Suite Professional.app
```

### 2. Clone the Repository
Clone this repository to get the setup script:
```bash
git clone https://github.com/anbuinfosec/burp-pro-mac.git
cd burp-pro-mac
```

### 3. Make the Script Executable
```bash
chmod +x setup.sh
```

---

## Usage

Run the script with the following options:

### 1. Setup Burp Suite
To set up Burp Suite with required configurations:
```bash
sudo ./setup.sh -setup
```

### 2. Fix Quarantine Issues
To fix the `"Burp Suite Professional is damaged and can't be opened"` error:
```bash
sudo ./setup.sh -fix
```

### 3. Help Menu
To display usage and developer information:
```bash
./setup.sh -help
```

---

## What the Script Does

1. **Downloads the Keygen**: Retrieves the required `BurpLoaderKeygen.jar` from the [GitHub Repository](https://github.com/anbuinfosec/burp-pro-mac).
2. **Modifies Configuration**: Adds necessary JVM options to `vmoptions.txt` for Burp Suite.
3. **Handles Errors**: Resolves macOS quarantine issues for downloaded applications.

---

## Download Keygen
The script automatically downloads the keygen from the following location:
[BurpLoaderKeygen.jar](https://github.com/anbuinfosec/burp-pro-mac/releases/download/Letest/BurpLoaderKeygen.jar)

---

## Notes

- Ensure the `BurpLoaderKeygen.jar` is downloaded successfully to the application resource directory.
- The script is designed for **macOS** users and assumes a specific Burp Suite installation path.

---

**Developed by [@anbuinfosec](https://github.com/anbuinfosec)**

---