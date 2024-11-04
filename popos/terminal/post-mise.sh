~/.local/bin/mise use --global node@lts
~/.local/bin/mise use --global go@latest
~/.local/bin/mise use --global python@latest
~/.local/bin/mise use --global java@latest
~/.local/bin/mise use --global ruby@3.3
~/.local/bin/mise x ruby -- gem install rails --no-document
bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y
