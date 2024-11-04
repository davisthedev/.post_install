cd /tmp

# Set GitHub API URL for the latest Bitwarden release
API_URL="https://api.github.com/repos/bitwarden/clients/releases"

# Fetch all AppImage URLs for Bitwarden releases
ALL_URLS=$(wget -qO- "$API_URL" | grep -oP '"browser_download_url":\s*"\K[^"]*Bitwarden-.*-x86_64\.AppImage')

# Sort URLs to get the highest version number
LATEST_URL=$(echo "$ALL_URLS" | sort -V | tail -n 1)

# Check if a URL was found
if [ -z "$LATEST_URL" ]; then
    echo "Error: Could not find a download URL for the Bitwarden AppImage."
    exit 1
fi

# Extract the filename from the URL
FILENAME=$(basename "$LATEST_URL")

wget -q --show-progress -O "$FILENAME" "$LATEST_URL"

ail-cli integrate "$FILENAME"

cd -
