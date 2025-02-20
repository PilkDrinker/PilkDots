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

# Function to display an error message and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Check if the script is run as root and exit if true
if [ "$EUID" -eq 0 ]; then
    error_exit "This script should not be run as root. Please run it as a regular user."
fi

# Enable multilib if not already enabled
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu
else
    echo "Multilib repository is already enabled."
    sleep 2
    clear
fi

# Detect if yay is installed, if not, ask user if they want to install it + dependency installation.
if ! command_exists yay; then
    echo "yay not detected, proceeding with install script..."
    if ask_yn "Do you want to install yay (AUR helper)?"; then
        echo "Installing yay (AUR helper)..."
        sudo pacman -Syu --needed base-devel git
        git clone https://aur.archlinux.org/yay.git ~/yay
        (cd ~/yay && makepkg -si) || error_exit "Failed to install yay"
        rm -rf ~/yay
        clear
    else
        echo "yay not detected, skipping installation and proceeding with dependency installation..."
        sleep 2
        clear
    fi
fi

# Detect if paru is installed, if not, ask user if they want to install it + dependency installation.
if ! command_exists paru; then
    echo "paru not detected, proceeding with install script..."
    if ask_yn "Do you want to install paru (AUR helper)? (You don't have to do this if you already installed yay)"; then
        echo "Installing paru (AUR helper)..."
        sudo pacman -Syu --needed base-devel git
        git clone https://aur.archlinux.org/paru.git ~/paru
        (cd ~/paru && makepkg -si) || error_exit "Failed to install paru"
        rm -rf ~/paru
        clear
    else
        echo "paru detected, skipping installation and proceeding with dependency installation..."
        sleep 2
        clear
    fi
fi

# Install dependencies with yay or paru
if command_exists yay; then
    echo ""
    if ask_yn "Do you want to install required dependencies with yay (very recommended)?"; then
        yay -Syu \
            hyprland waybar waypaper swww rofi-wayland swaync python-pipx nemo kitty pavucontrol \
            gtk2 gtk3 nwg-look fastfetch zsh nerd-fonts-complete networkmanager networkmanager-qt \
            nm-connection-editor xcur2png gsettings-qt hyprshot wlogout ttf-fira-sans ttf-firecode-nerd \
            otf-droid-nerd texlive-fontsextra || error_exit "Failed to install dependencies with yay"
    else
        echo "Skipping dependency installation..."
        clear
    fi
elif command_exists paru; then
    echo ""
    if ask_yn "Do you want to install required dependencies with paru (very recommended)?"; then
        paru -Syu \
            hyprland waybar waypaper swww rofi-wayland swaync python-pipx nemo kitty pavucontrol \
            gtk2 gtk3 nwg-look fastfetch zsh nerd-fonts-complete networkmanager networkmanager-qt \
            nm-connection-editor xcur2png gsettings-qt hyprshot wlogout ttf-fira-sans ttf-firecode-nerd \
            otf-droid-nerd texlive-fontsextra || error_exit "Failed to install dependencies with paru"
    else
        echo "Skipping dependency installation..."
        sleep 2
        clear
    fi
else
    error_exit "Neither yay nor paru is installed. Please install one of them to proceed."
fi

# Oh My Zsh
echo ""
if ask_yn "Do you want to install Oh My Zsh?"; then
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed."
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || error_exit "Failed to install Oh My Zsh"
    fi
else
    echo "Skipping Oh My Zsh installation..."
    sleep 2
    clear
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

# Check and create directories if they don't exist
[ ! -d "$HOME/.config" ] && mkdir -p "$HOME/.config"
[ ! -d "$HOME/.themes" ] && mkdir -p "$HOME/.themes"
[ ! -d "$HOME/wallpaper" ] && mkdir -p "$HOME/wallpaper"

echo "Backing up existing configurations to $BACKUP_DIR"
copy_with_backup "$SCRIPT_DIR/.config/" "$HOME/.config/"
copy_with_backup "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
copy_with_backup "$SCRIPT_DIR/wallpaper" "$HOME/wallpaper"
copy_with_backup "$SCRIPT_DIR/.themes/" "$HOME/.themes/"

# Nerd Fonts
echo ""
if ask_yn "Do you want to install Nerd Fonts (Recommended) (~8GB download)?"; then
    git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
    ~/nerd-fonts/install.sh || error_exit "Failed to install Nerd Fonts"
    rm -rf ~/nerd-fonts
else
    echo "Skipping Nerd Fonts installation..."
    sleep 2
    clear
fi

echo ""
echo "Ready in 3..."
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "<3"
