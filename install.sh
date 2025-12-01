#!/bin/bash
set -e

# Configs
if [ "$EUID" -eq 0 ]; then
  echo "This script should not be run as root. Please run it as a regular user."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "/etc/doas.conf" ]; then
  export ROOT="doas"
elif [ -f "/usr/bin/sudo" ]; then
  export ROOT="sudo"
else
  echo "Doas and sudo not found. Install doas or sudo!"
  exit 1
fi

# Commands
ask_ny() {
  while true; do
      read -p "$1 (y/n): " ny
      case $ny in
          [Yy]* ) return 0;;
          [Nn]* ) return 1;;
          * ) echo "Please answer y or n.";;
      esac
  done
}

ask_choice() {
  local prompt="$1"
  local options="$2"
  local choice
  while true; do
      read -p "$prompt " choice
      if [[ $options == *"$choice"* ]]; then
          echo "$choice"
          return
      else
          echo "Invalid choice. Please try again."
      fi
  done
}

copy_with_backup() {
    local src=$1
    local dest=$2
    if [ -e "$dest" ]; then
        echo "Backing up existing $(basename "$dest") to $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR"
    fi
    cp -rf "$src" "$dest"
}

# Main selection of distro
choice=$(ask_choice "Which distro do you have?: (1) Arch Linux, (2) Gentoo Linux" "1 2")

case $choice in
  1)
    echo ""
    # Enable multilib if not already enabled
    if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
      echo "Enabling multilib repository..."
      echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | "$ROOT" tee -a /etc/pacman.conf
      "$ROOT" pacman -Syu
    else
      echo "Multilib repository is already enabled."
      sleep 2
    fi
    if [ ! -f "/usr/bin/yay" ]; then
      echo ""
      echo "Yay not installed. Installing yay (AUR helper)..."
      "$ROOT" pacman -Syu --needed base-devel git
      git clone "https://aur.archlinux.org/yay.git" "$HOME/.yay"
      cd "$HOME/.yay"
      makepkg -si
      rm -rf "$HOME/.yay"
    fi
     
    echo ""
    if ask_ny "Do you want to install dependencies (very recommended)?"; then
      yay -Syu --noconfirm --needed \
      hyprland hyprgrass waybar rofi python-pipx alacritty xdg-desktop-portal \
      gtk2 gtk3 nwg-look fastfetch zsh grim satty xdg-desktop-portal-gtk swaybg ttf-firacode-nerd  \
      xcur2png gsettings-qt slurp wlogout thunar neovim wl-clipboard xdg-desktop-portal-wlr nerd-fonts-jetbrains-mono \
    else
      echo "Skipping dependency installation..."          
    fi
    ;;
  2)
    # Dependencies
    echo ""
    if ask_ny "Do you want to install dependencies (very recommended)?"; then
    "$ROOT" emerge -navq eselect-repository
    "$ROOT" eselect repository enable librewolf kzd guru steam-overlay
    "$ROOT" emerge --sync
    "$ROOT" cp -rf ./gentoo/package.accept_keywords/ /etc/portage/
    "$ROOT" cp -rf ./gentoo/package.use/ /etc/portage/
    "$ROOT" emerge -navq \
            hyprland wlogout waybar rofi neovim xdg-desktop-portal swaybg \
            dev-python/pipx thunar alacritty dev-perl/Gtk2 wl-clipboard swaylock \
            dev-perl/Gtk3 xcur2png nwg-look fastfetch zsh grim slurp satty wlroots xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
    else
      echo "Skipping dependency installation..."
    fi
    ;;
  *)
    echo "Invalid choice. Please try again."
    ;;
esac

# Oh My Zsh
echo ""
if [ ! -d "$HOME/.oh-my-zsh/" ]; then
  echo "Oh My Zsh Not found. Installing..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
fi

# Copying files
echo ""
echo "Copying dotfiles files..."
sleep 1
BACKUP_DIR="$HOME/backup_$(date +%Y%m%d_%H%M%S)"
[ ! -d "$BACKUP_DIR" ] && mkdir -p "$BACKUP_DIR"
[ ! -d "$HOME/.config" ] && mkdir -p "$HOME/.config"
[ ! -d "$HOME/.themes" ] && mkdir -p "$HOME/.themes"
[ ! -d "$HOME/wallpaper" ] && mkdir -p "$HOME/wallpaper"

echo "Backing up existing configurations to $BACKUP_DIR"
copy_with_backup "$SCRIPT_DIR/.config/" "$HOME/.config/"
copy_with_backup "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
copy_with_backup "$SCRIPT_DIR/wallpaper" "$HOME/wallpaper"
copy_with_backup "$SCRIPT_DIR/.themes/" "$HOME/.themes/"
sleep 1

# Nerd Fonts
echo ""
if [ ! -d "$HOME/nerd-fonts/" ]; then
  if ask_ny "Do you want Nerd Fonts (Recommended) (8GB)?"; then
    git clone -j$(nproc --all) --depth=1 "https://github.com/ryanoasis/nerd-fonts.git" "$HOME/nerd-fonts"
    cd "$HOME/nerd-fonts/"
    ./install.sh
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    mv MesloLGS\ NF\ * "$HOME/.local/share/fonts/NerdFonts/"
    rm -rf "$HOME/nerd-fonts"
  else
    echo "Skipping Nerd Fonts installation..."
  fi
fi
sleep 1
echo "Done!"
