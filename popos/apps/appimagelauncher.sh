RELEASE_TAG="continuous"

# Set temporary download directory
TMP_DIR="/tmp"
cd "$TMP_DIR"

# Fetch the download URL for the specified release tag
RELEASE_URL="https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/tags/$RELEASE_TAG"
DOWNLOAD_URL=$(wget -qO- "$RELEASE_URL" | grep -oP '"browser_download_url":\s*"\K[^"]*amd64\.deb')

# Check if the URL was found
if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find a download URL for release tag $RELEASE_TAG."
    exit 1
fi

# Extract the filename from the URL
FILENAME=$(basename "$DOWNLOAD_URL")

wget -q -O "$FILENAME" "$DOWNLOAD_URL"

sudo dpkg -i "$FILENAME"

sudo apt-get install -f -y

rm "$FILENAME"

cd -
