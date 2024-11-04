#!/bin/bash

# Set temporary directory and install URL
TMP_DIR="/tmp"
cd "$TMP_DIR"

# Fetch the latest download URL with wget
ARCHIVE_URL=$(wget -qO- 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' \
    | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3":"$4}' | tr -d '", ')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

# Download the archive to /tmp
echo "Downloading $ARCHIVE_FILENAME to $TMP_DIR..."
wget -q --show-progress -O "$TMP_DIR/$ARCHIVE_FILENAME" "$ARCHIVE_URL"

# Extract the downloaded archive
echo "Extracting $ARCHIVE_FILENAME..."
tar -xzf "$ARCHIVE_FILENAME"

# Get the extracted folder name (assuming it's the first directory in the archive)
EXTRACTED_DIR=$(tar -tf "$ARCHIVE_FILENAME" | head -1 | cut -f1 -d"/")

# Navigate into the extracted directory and run JetBrains Toolbox
echo "Running JetBrains Toolbox from $EXTRACTED_DIR..."
cd "$EXTRACTED_DIR" && ./jetbrains-toolbox

