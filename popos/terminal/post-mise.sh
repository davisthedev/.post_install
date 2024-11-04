mise use --global node@lts
mise use --global go@latest
mise use --global python@latest
mise use --global java@latest
mise use --global ruby@3.3
mise x ruby -- gem install rails --no-document
bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y
