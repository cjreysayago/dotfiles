#!/bin/bash

echo "Starting environment setup 🙂"

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install base software
echo "Installing base software..."
sudo apt install -y build-essential sh tmux curl git unzip
sudo snap install go --classic
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list && \
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
  sudo apt update && sudo apt install -y 1password-cli

# Install PHP (corrected URL for Linux)
echo "Installing PHP..."
sh -c "$(curl -fsSL https://php.new/install/linux)"

# Install OhmyZsh
echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install NodeJS LTS via nvm
echo "Installing NodeJS LTS via nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
nvm install --lts

# Install JetBrains Nerd Fonts
echo "Installing JetBrains Nerd Fonts..."
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv

# Clone and apply dotfiles
echo "Applying dotfiles..."
ln -sf ./zsh/.zshrc ~/.zshrc
ln -sf ./tmux/.tmux.conf ~/.tmux.conf
ln -sf ./nvim ~/.config/nvim

# Final message
echo "Your environment is ready! Happy shipping! 🚢"

