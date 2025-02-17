#!/bin/bash

echo "Starting environment setup 🙂"

# Detect OS and Ubuntu version
ios="$(uname -s)"
ubuntu_version=""
if [ "$ios" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "ubuntu" ] && [ "${VERSION_ID%%.*}" -ge 24 ]; then
            ubuntu_version="$VERSION_ID"
        fi
    fi
fi

if [ -n "$ubuntu_version" ]; then
    echo "Detected Ubuntu $ubuntu_version system"
    # Update and upgrade system packages
    echo "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    
    # Install base software
    echo "Installing base software..."
    sudo apt install -y build-essential tmux curl git unzip zsh-autosuggestions zsh-syntax-highlighting zsh
    sudo snap install go --classic
    sudo snap install nvim --classic
    
    # Install 1Password CLI
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

elif [ "$ios" = "Darwin" ]; then
    echo "Detected macOS system"
    
    # Install Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed"
    fi
    
    echo "Installing base software..."
    brew install tmux curl git unzip zsh-autosuggestions zsh-syntax-highlighting
    brew install neovim go
    brew install --cask ghostty
    
    # Install Laravel Herd
    echo "Installing Laravel Herd..."
    brew install --cask herd
fi

# Install OhmyZsh
echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
source ~/.zshrc

echo "Adding plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom/}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom/}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# Install JetBrains Nerd Fonts
echo "Installing JetBrains Nerd Fonts..."
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv

# Clone and apply dotfiles
echo "Applying dotfiles..."
cp ~/.zshrc ~/.zshrc_bu
ln -sf "$PWD/zsh/.zshrc" ~/.zshrc
ln -sf "$PWD/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "$PWD/nvim" ~/.config/nvim

# Install NodeJS LTS via nvm
echo "Installing NodeJS LTS via nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
nvm install --lts

# Install PHP (Ubuntu >= 24.04 only)
if [ -n "$ubuntu_version" ]; then
    echo "Installing PHP..."
    /bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
fi

# Install Bun
echo "Installing Bun"
curl -fsSL https://bun.sh/install | bash

# Add tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf

# Final message
echo "Your environment is ready! Happy shipping! 🚢"

