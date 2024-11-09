#!/bin/bash
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

# Main selection of distro
choice=$(ask_choice "Which distro do you have?: (1) Arch Linux, (2) Gentoo Linux" "1 2")

case $choice in
    1)
        echo "Arch Linux not implemented yet."
        ;;
    2)
        # Loop to choose doas or sudo with validation
        root_choice=$(ask_choice "Are you using doas or sudo?: (1) Doas, (2) Sudo" "1 2")
                case $root_choice in
                    1)
                        # Repos doas
                        echo ""
                        if ask_yn "Do you have enabled kzd, guru, steam-overlay repos?"; then
                            doas emerge -navq eselect-repository
                            doas eselect repository enable librewolf kzd guru steam-overlay
                            doas emerge --sync
                        else
                            echo "Skipping repository setup..."
                        fi

                        # Dependencies doas
                        echo ""
                        if ask_ny "Do you want to install dependencies (very recommended)?"; then
                            doas cp -rf ./gentoo/package.accept_keywords/ /etc/portage/
                            doas cp -rf ./gentoo/package.use/ /etc/portage/
                            doas emerge -navq hyprland wlogout waybar swww rofi swaync dev-python/pipx thunar kitty pavucontrol dev-perl/Gtk2 dev-perl/Gtk3 xcur2png nwg-look fastfetch zsh hyprshot networkmanager networkmanager-qt
                            pipx install waypaper
                            doas cp -rf ~/.local/bin/waypaper /usr/bin/
                        else
                            echo "Skipping dependency installation..."
                        fi
                        ;;
                    2)
                        # Repos sudo
                        echo ""
                        if ask_yn "Do you have enabled kzd, guru, steam-overlay repos?"; then
                            sudo emerge -navq eselect-repository
                            sudo eselect repository enable librewolf kzd guru steam-overlay
                            sudo emerge --sync
                        else
                            echo "Skipping repository setup..."
                        fi

                        # Dependencies sudo
                        echo ""
                        if ask_ny "Do you want to install dependencies (very recommended)?"; then
                            sudo cp -rf ./gentoo/package.accept_keywords/ /etc/portage/
                            sudo cp -rf ./gentoo/package.use/ /etc/portage/
                            sudo emerge -navq hyprland wlogout waybar swww rofi swaync dev-python/pipx thunar kitty pavucontrol dev-perl/Gtk2 dev-perl/Gtk3 xcur2png nwg-look fastfetch zsh hyprshot networkmanager networkmanager-qt
                            pipx install waypaper
                            sudo cp -rf ~/.local/bin/waypaper /usr/bin/
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
                if ask_yn "Do you have Oh My Zsh?"; then
                    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
                else
                    echo "Skipping Oh My Zsh installation..."
                fi
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
                sleep 1
                # Nerd Fonts
                    echo ""
                    if ask_ny "Do you want Nerd Fonts (Recommended) (8GB)?"; then
                    git clone -j$(nproc --all) --depth=1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
                    cd ~/nerd-fonts/
                    ./install.sh
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
                    cp MesloLGS\ NF\ *.ttf ~/.local/share/fonts/NerdFonts/
                else
                    echo "Skipping Nerd Fonts installation..."
                fi
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
echo ""
echo "Ready in 3.."
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "<3"
