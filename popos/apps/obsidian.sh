TMP_DIR="/tmp"
cd "$TMP_DIR"

# Define the GitHub API URL for the latest release of Obsidian
API_URL="https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"

# Fetch the latest AppImage download URL, excluding arm64
DOWNLOAD_URL=$(wget -qO- "$API_URL" | grep -oP '"browser_download_url":\s*"\K[^"]*[^arm64]\.AppImage')

# Check if the URL was found
if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find a non-ARM download URL for the Obsidian AppImage."
    exit 1
fi

# Extract the filename from the URL
FILENAME=$(basename "$DOWNLOAD_URL")

wget -q -O "$FILENAME" "$DOWNLOAD_URL"

ail-cli integrate "$FILENAME"

cd -