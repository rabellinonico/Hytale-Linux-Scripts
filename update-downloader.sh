#!/bin/bash

# update-downloader.sh
# Checks if Hytale-Downloader is up to date and updates it if outdated
# Installs it in /usr/local/bin

# Variables
DOWNLOADER="hytale-downloader"
INSTALL_DIR="/usr/local/bin"
DOWNLOAD_URL="https://downloader.hytale.com/hytale-downloader.zip"
TMP_ZIP="/tmp/hytale-downloader.zip"
TMP_DIR="/tmp/hytale-downloader-temp"

# Function to download and install the downloader
update_downloader() {
    echo -e "\n====================================="
    echo "Updating Hytale-Downloader..."
    echo "=====================================\n"

    mkdir -p "$TMP_DIR"

    wget -O "$TMP_ZIP" "$DOWNLOAD_URL"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download $DOWNLOAD_URL"
        exit 1
    fi

    unzip -o "$TMP_ZIP" "hytale-downloader-linux-amd64" -d "$TMP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract hytale-downloader-linux-amd64 from zip"
        exit 1
    fi

    echo "Installing to $INSTALL_DIR (requires sudo)..."
    sudo mv "$TMP_DIR/hytale-downloader-linux-amd64" "$INSTALL_DIR/hytale-downloader"
    sudo chmod +x "$INSTALL_DIR/hytale-downloader"

    rm -rf "$TMP_DIR" "$TMP_ZIP"

    echo -e "\nHytale-Downloader has been updated successfully!"
}

# Main logic

# Check if downloader exists in PATH
if ! command -v $DOWNLOADER &> /dev/null; then
    echo "Hytale-Downloader not found. Installing..."
    update_downloader
    exit 0
fi

# Check for updates
echo "Checking Hytale-Downloader for updates..."
CHECK=$($DOWNLOADER -check-update 2>&1)
echo "$CHECK"

# If outdated, update it
if echo "$CHECK" | grep -iq "outdated"; then
    update_downloader
    exit 0
fi
