#!/bin/bash

# Change to the home directory
cd "$HOME" || { echo "Failed to navigate to home directory"; exit 1; }

# Define the repository URL for your .dotfiles repo
REPO_URL="https://github.com/davisthedev/.dotfiles.git"  # Replace with your actual repository URL


if [ ! -d "$HOME/.dotfiles" ]; then
  # Clone the repository
  git clone "$REPO_URL" .dotfiles

  if [ -f "$HOME/.bashrc" ]; then
      mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
  fi

  cd .dotfiles
  for dir in */; do
      stow "$dir"
  done

  source "$HOME/.bashrc"
fi

cd -
