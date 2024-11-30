#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to ask a yes/no question with a custom prompt
ask_yn() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;  # Return 0 (success) for yes
            [Nn]* ) return 1;;  # Return 1 (failure) for no
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Enable multilib if not already enabled
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu
fi

# Install yay if not installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    sudo pacman -Syu --needed base-devel git
    git clone https://aur.archlinux.org/yay.git ~/yay
    (cd ~/yay && makepkg -si)
    rm -rf ~/yay
fi

# Install dependencies
echo ""
if ask_yn "Do you want to install required dependencies (very recommended)?"; then
    yay -Syu hyprland waybar waypaper swww rofi-wayland swaync python-pipx nemo kitty pavucontrol gtk2 gtk3 nwg-look fastfetch zsh nerd-fonts-complete networkmanager networkmanager-qt nm-connection-editor xcur2png gsettings-qt hyprshot wlogout ttf-fira-sans ttf-firecode-nerd otf-droid-nerd texlive-fontsextra
else
    echo "Skipping dependency installation..."
fi

# Oh My Zsh
echo ""
if ask_yn "Do you want to install Oh My Zsh?"; then
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed."
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
else
    echo "Skipping Oh My Zsh installation..."
fi

# Copy configuration files
echo ""
echo "Copying configuration files..."
sleep 1

# Create backup of existing configurations
BACKUP_DIR="$HOME/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

copy_with_backup() {
    local src=$1
    local dest=$2
    if [ -e "$dest" ]; then
        echo "Backing up existing $(basename "$dest") to $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR"
    fi
    cp -rf "$src" "$dest"
}

echo "Backing up existing configurations to $BACKUP_DIR"
copy_with_backup "$SCRIPT_DIR/.config/" "$HOME/.config/"
copy_with_backup "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
copy_with_backup "$SCRIPT_DIR/wallpaper" "$HOME/wallpaper"
copy_with_backup "$SCRIPT_DIR/.themes/" "$HOME/.themes/"

# Nerd Fonts
echo ""
if ask_yn "Do you want to install Nerd Fonts (Recommended) (~8GB download)?"; then
    git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
    ~/nerd-fonts/install.sh
    rm -rf ~/nerd-fonts
else
    echo "Skipping Nerd Fonts installation..."
fi

echo ""
echo "Ready in 3..."
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "<3"
