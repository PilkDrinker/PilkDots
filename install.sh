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

ask_yn() {
    while true; do
        read -p "$1 (y/n): " yn
        case $ny in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# istro
while true; do
    echo "Which distro do you have?:"
    echo "1) Arch Linux"
    echo "2) Gentoo Linux"
    read -p "Enter your choice (1, 2): " choice

    case $choice in
        1)
            echo "Later/tmr"
            ;;
        2)
            while true; do
                echo "Are you using doas or sudo?"
                echo "1) Doas"
                echo "2) Sudo"
                read -p "Enter your choice (1, 2): " root_choice

                case $root_choice in
                    1)
                        # Repos doas
                        if ask_yn "Do you have enabled kzd, guru, steam-overlay repos?"; then
                            doas emerge -navq eselect-repository
                            doas eselect repository enable librewolf kzd guru steam-overlay
                            doas emerge --sync
                        else
                            echo "Skipping repository setup..."
                        fi

                        # Dependencies doas
                        if ask_ny "Do you want to install dependencies (very recommended)?"; then
                            doas cp -rf ./gentoo/package.accept_keywords/ /etc/portage/package.accept_keywords
                            doas emerge -navq hyprland wlogout waybar swww rofi swaync dev-python/pipx thunar kitty pavucontrol dev-perl/Gtk2 dev-perl/Gtk3 xcur2png nwg-look fastfetch zsh hyprshot networkmanager networkmanager-qt
                        else
                            echo "Skipping dependency installation..."
                        fi
                        ;;
                    2)
                        # Repos sudo
                        if ask_yn "Do you have enabled kzd, guru, steam-overlay repos?"; then
                            sudo emerge -navq eselect-repository
                            sudo eselect repository enable librewolf kzd guru steam-overlay
                            sudo emerge --sync
                        else
                            echo "Skipping repository setup..."
                        fi

                        # Dependencies sudo
                        if ask_ny "Do you want to install dependencies (very recommended)?"; then
                            sudo cp -rf ./gentoo/package.accept_keywords/ /etc/portage/package.accept_keywords
                            sudo emerge -navq hyprland wlogout waybar swww rofi swaync dev-python/pipx thunar kitty pavucontrol dev-perl/Gtk2 dev-perl/Gtk3 xcur2png nwg-look fastfetch zsh hyprshot networkmanager networkmanager-qt
                        else
                            echo "Skipping dependency installation..."
                        fi
                        ;;
                    *)
                        echo "Invalid choice. Please try again."
                        ;;
                esac

                # Oh My Zsh
                if ask_yn "Do you have Oh My Zsh?"; then
                    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
                else
                    echo "Skipping Oh My Zsh installation..."
                fi

                echo "Copying configuration files..."
                echo "./.config > ~/.config"
                cp -rf ./.config/ ~/.config/
                sleep 1
                echo "./.zshrc > ~/.zshrc"
                cp -rf ./.zshrc ~/.zshrc
                sleep 1
                echo "./wallpaper > ~/wallpaper"
                cp -rf ./wallpaper ~/wallpaper
                sleep 1
                echo "./.themes > ~/.themes"
                cp -rf ./.themes ~/.themes
                sleep 1
                # Nerd Fonts
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
            done
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
