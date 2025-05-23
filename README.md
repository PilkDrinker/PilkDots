# Pilk's dotfiles

These are my current dotfiles.
A very clean look for hyprland. As well as my first ever rice 🤓

Most of these original config files were made by other [people](https://github.com/PilkDrinker/PilkDots?tab=readme-ov-file#original-work) in the community and then alterted by me.
A lot of the heavy work was made by [Stephan Raabe](https://github.com/mylinuxforwork) (ML4W) who made the inital dotfiles I edited.

Also a big thanks to [Ksawlii](https://github.com/Ksawlii) and [Thomas Brugman](https://github.com/Githubguy132010) for making the installation scripts! 💙

> [!NOTE]
> I no longer use hyprland, so if you find any issues with these dotfiles try resolving them yourself and/or make a pull request.

### Contents
- [Automatic Installation for Arch](https://github.com/PilkDrinker/PilkDots?tab=readme-ov-file#installationforarch)
- [Automatic Installation for Gentoo](https://github.com/PilkDrinker/PilkDots?tab=readme-ov-file#installationforgentoo)
- [Manual Installation](https://github.com/PilkDrinker/PilkDots?tab=readme-ov-file#manual-installation)
- [Extra configuration](https://github.com/PilkDrinker/PilkDots?tab=readme-ov-file#extra-configuration)
- [Original work](https://github.com/PilkDrinker/PilkDots?tab=readme-ov-file#original-work)


## Screenshots
Default
### ![alt text](https://github.com/PilkDrinker/PilkDots/blob/master/screenshots/Sreenshot3.png)
With Borders
### ![alt text](https://github.com/PilkDrinker/dotfiles/blob/master/screenshots/Screenshot1.png)

### ![alt text](https://github.com/PilkDrinker/dotfiles/blob/master/screenshots/sc2.gif)

### ![alt text](https://github.com/PilkDrinker/dotfiles/blob/master/screenshots/sc1.gif)




 
# Installation for Arch and Gentoo
To run the installation script for Arch and Gentoo, copy and paste these commands in your terminal:
```
git clone https://github.com/PilkDrinker/PilkDots
cd PilkDots
./install.sh
```

Huge thanks to [Ksawlii](https://github.com/Ksawlii) and [Thomas Brugman](https://github.com/Githubguy132010) for making these installtion scripts! <3

> [!NOTE]
> This installation script is currently limited to Gentoo and Arch (and derivatives of Arch), and is not 100% done. Some features may need to be configured manually.

> [!WARNING]
> Do not run `yay` or `paru` as root. Running these AUR helpers as root can cause permanent damage to your system. Always run them as a regular user.

# Manual Installation

1. Install the dependencies with your preffered AUR helper:

For yay:

```
yay -S hyprland wlogout waypaper waybar swww rofi-wayland swaync nemo kitty pavucontrol gtk3 gtk2 xcur2png gsettings nwg-look fastfetch zsh oh-my-zsh-git hyprshot networkmanager networkmanager-qt nm-connection-editor ttf-firacode-nerd nerd-fonts-jetbrains-mono
```

For paru:

```
paru -S hyprland wlogout waypaper waybar swww rofi-wayland swaync nemo kitty pavucontrol gtk3 gtk2 xcur2png gsettings nwg-look fastfetch zsh oh-my-zsh-git hyprshot networkmanager networkmanager-qt nm-connection-editor ttf-firacode-nerd nerd-fonts-jetbrains-mono
```

2. Clone the repository with:

```
git clone https://github.com/PilkDrinker/PilkDots.git
```
3. Move the .config, .themes, and wallpaper into your home directory with:

```
sudo mv .config .themes wallpaper /home/YOURUSERNAMEHERE
```

4. Install the listed fonts. (You can find them in the ```Required Fonts``` file.)
5. Set up zsh (Optional)
6. Change your GTK theme and icons (Using GTK-look/nwg-look or the terminal)


## Extra configuration
There is a few optional configurations and alts in the .config directory (waybar borders etc.) Feel free to alter whatever you want to make it your own style. 🥰

You can also changed your desired Wallpaper directory in .config/waypaper/config.ini

For the Theme to work in certain GTK apps, you might need to add the theme's assets diretory to ~/.config/assets


## Original work
Here's a list of the people who's original work I've altered (There might have been more, but I can't remember)

- [Stephan Raabe's ML4W](https://github.com/mylinuxforwork)
- [LireB's Fastfetch](https://github.com/LierB/fastfetch)
- [Newmals' Rofi themes](https://github.com/newmanls/rofi-themes-collection)
- [EliverLara's Sweet Themes](https://github.com/EliverLara/Sweet)
  


