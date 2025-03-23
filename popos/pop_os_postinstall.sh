#!/bin/bash
set -e

# Base
# sudo apt update
# sudo apt -y upgrade
# sudo apt -y dist-upgrade
# sudo apt -y autoremove
# sudo apt autoclean
# sudo fwupdmgr get-devices
# sudo fwupdmgr get-updates
# sudo fwupdmgr update
sudo apt-add-repository universe
sudo apt -y install curl git unzip fzf ripgrep bat eza btop fd-find stow 
sudo apt -y install build-essential pkg-config autoconf clang ninja-build gettext cmake libfuse2
sudo apt -y install alacritty flameshot vlc vim

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Flatpak
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.bitwarden.desktop md.obsidian.Obsidian

# Docker
# Add the official Docker repo
sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install Docker engine and standard plugins
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}

# Limit log size to avoid running out of disk
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

# Fonts
mkdir -p ~/.local/share/fonts

cd /tmp
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaFont
cp CascadiaFont/*.ttf ~/.local/share/fonts
rm -rf CascadiaMono.zip CascadiaFont

wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
cp JetBrainsMono/*.ttf ~/.local/share/fonts
rm -rf JetBrainsMono.zip JetBrainsMono

fc-cache
cd -

# AppimageLauncher
cd /tmp || exit 1

# Fetch the AppImageLauncher deb URL and save it in a temporary file.
wget -qO- "https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/tags/continuous" \
  | grep -oP '"browser_download_url":\s*"\K[^"]*amd64\.deb' > /tmp/appimagelauncher_url

# If no URL was found, report an error and exit.
if [ ! -s /tmp/appimagelauncher_url ]; then
  echo "Error: Could not find a download URL for release tag continuous."
  exit 1
fi

# Use the URL stored in the file to download, install, and then remove the package.
wget -q -O "$(basename "$(cat /tmp/appimagelauncher_url)")" "$(cat /tmp/appimagelauncher_url)"
sudo dpkg -i "$(basename "$(cat /tmp/appimagelauncher_url)")"
sudo apt-get install -f -y
rm "$(basename "$(cat /tmp/appimagelauncher_url)")" /tmp/appimagelauncher_url

cd -

# Arduino
cd /tmp || exit 1

# Fetch the download URL for the latest Arduino IDE Linux 64-bit AppImage
wget -qO- "https://api.github.com/repos/arduino/arduino-ide/releases/latest" \
  | grep -oP '"browser_download_url":\s*"\K[^"]*Linux_64bit\.AppImage' > /tmp/arduino_ide_url

# Exit if the URL was not found
if [ ! -s /tmp/arduino_ide_url ]; then
  echo "Error: Could not find a download URL for the Arduino IDE AppImage."
  exit 1
fi

# Download the AppImage using its basename and then integrate it with ail-cli
wget -q -O "$(basename "$(cat /tmp/arduino_ide_url)")" "$(cat /tmp/arduino_ide_url)"
ail-cli integrate "$(basename "$(cat /tmp/arduino_ide_url)")"

rm /tmp/arduino_ide_url

cd -

# LazyDocker
cd /tmp
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
rm lazydocker.tar.gz lazydocker
cd -

# LazyGit
cd /tmp
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit
cd -

# Mise
# Install mise for managing multiple versions of languages. See https://mise.jdx.dev/
sudo apt update -y && sudo apt install -y gpg wget curl
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise
mise use --global node@lts
mise use --global go@latest
mise use --global python@latest
mise use --global java@latest
bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y

# Neovim
# cd /tmp
# wget -O nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
# tar -xf nvim.tar.gz
# sudo install nvim-linux64/bin/nvim /usr/local/bin/nvim
# sudo cp -R nvim-linux64/lib /usr/local/
# sudo cp -R nvim-linux64/share /usr/local/
# rm -rf nvim-linux64 nvim.tar.gz
# cd -

# Spotify
# Stream music using https://spotify.com
# curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
# echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
# sudo apt update -y
# sudo apt install -y spotify-client

# Typora
wget -qO - https://typora.io/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc
sudo add-apt-repository -y 'deb https://typora.io/linux ./'
sudo apt update -y
sudo apt install -y typora

# zsh
sudo apt -y install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions