#!/bin/bash

# Function to ask a yes/no question with a custom prompt
ask_yn() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 1;;
            [Nn]* ) return 0;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Enable multilib if not already enabled
if ! grep -q '\[multilib\]' /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu
fi

# Install yay if not installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/yay.git ~/yay
    (cd ~/yay && makepkg -si)
fi

# Install dependencies
echo ""
if ask_yn "Do you want to install required dependencies (very recommended)?"; then
    sudo pacman -Syu
    yay -S hyprland waybar swww rofi swaync python-pipx thunar kitty pavucontrol gtk2 gtk3 nwg-look fastfetch zsh nerd-fonts-complete networkmanager networkmanager-qt
    pipx install waypaper
else
    echo "Skipping dependency installation..."
fi

# Oh My Zsh
echo ""
if ask_yn "Do you want to install Oh My Zsh?"; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Skipping Oh My Zsh installation..."
fi

# Copy configuration files
echo ""
echo "Copying configuration files..."
sleep 1
echo "./.config > ~/.config"
cp -rf ./.config/ ~/
sleep 1
echo "./.zshrc > ~/.zshrc"
cp -rf ./.zshrc ~/.zshrc
sleep 1
echo "./wallpaper > ~/wallpaper"
cp -rf ./wallpaper ~/
sleep 1
echo "./.themes > ~/.themes"
cp -rf ./.themes ~/

# Nerd Fonts
echo ""
if ask_yn "Do you want Nerd Fonts (Recommended) (8GB)?"; then
    git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
    cd ~/nerd-fonts && ./install.sh
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
