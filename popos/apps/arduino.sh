cd /tmp

API_URL="https://api.github.com/repos/arduino/arduino-ide/releases/latest"

DOWNLOAD_URL=$(wget -qO- "$API_URL" | grep -oP '"browser_download_url":\s*"\K[^"]*Linux_64bit\.AppImage')

# Check if the URL was found
if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find a download URL for the Arduino IDE AppImage."
    exit 1
fi

# Download the AppImage to the current directory
FILENAME=$(basename "$DOWNLOAD_URL")
wget -q -O "$FILENAME" "$DOWNLOAD_URL"

ail-cli integrate "$FILENAME"

cd -
