#!/usr/bin/env bash

set -euo pipefail

# Update and install packages
sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
    alacritty \
    amberol \
    baobab \
    base-devel \
    bluetui \
    bluez \
    bluez-utils \
    brightnessctl \
    btop \
    cliphist \
    decibels \
    dosfstools \
    espeak-ng \
    espeakup \
    fastfetch \
    fd \
    file-roller \
    firefox \
    flatpak \
    fzf \
    git \
    gnome-calculator \
    gnome-calendar \
    gnome-characters \
    gnome-disk-utility \
    gnome-font-viewer \
    gnome-keyring \
    gnome-text-editor \
    grim \
    gvfs \
    gvfs-mtp \
    hypridle \
    hyprland \
    hyprlock \
    hyprpaper \
    hyprpicker \
    hyprpolkitagent \
    hyprshutdown \
    hyprsunset \
    inter-font \
    iotas \
    jq \
    loupe \
    lua51 \
    luarocks \
    ly \
    mako \
    man-db \
    nautilus \
    neovim \
    networkmanager \
    nodejs-lts-krypton \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    npm \
    papers \
    pipewire \
    pipewire-jack \
    pipewire-pulse \
    qt5-wayland \
    qt6-wayland \
    ripgrep \
    rofi \
    slurp \
    snapshot \
    speech-dispatcher \
    sushi \
    tmux \
    tree \
    tree-sitter-cli \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-material-symbols-variable \
    ttf-noto-nerd \
    waybar \
    wget \
    wiremix \
    wireplumber \
    xdg-desktop-portal \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland \
    xdg-user-dirs-gtk \
    zsh \
    zsh-completions

sudo pacman -S --needed --noconfirm --asdeps \
    7zip \
    arj \
    binutils \
    bzip3 \
    cdrtools \
    cpio \
    dpkg \
    lhasa \
    lrzip \
    rpmextract \
    squashfs-tools \
    unace \
    unrar \
    unzip \
    zip

flatpak install -y flathub org.gnome.Showtime

# Install themes
mkdir -p $HOME/.tmp
cd $HOME/.tmp

if ! pacman -Qi yaru-theme &>/dev/null; then
    if [[ ! -d yaru-theme ]]; then
        mkdir yaru-theme
        curl -o yaru-theme/PKGBUILD ...
    fi

    cd yaru-theme
    makepkg -si --noconfirm
fi

if ! pacman -Qi bibata-modern-classic-cursor-theme &>/dev/null; then
    if [[ ! -d bibata-modern-classic-cursor-theme ]]; then
        mkdir bibata-modern-classic-cursor-theme
        curl -o bibata-modern-classic-cursor-theme/PKGBUILD ...
    fi

    cd bibata-modern-classic-cursor-theme
    makepkg -si --noconfirm
fi

# Install yay
if ! command -v yay &>/dev/null; then
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd $HOME/.tmp
    rm -rf yay
fi

# Configure npm
mkdir -p "$HOME/.npm-global"
npm set prefix="$HOME/.npm-global"

# Configure zsh
if [[ ! -d "$HOME/.zsh" ]]; then
    mkdir "$HOME/.zsh"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi

chsh -s /usr/bin/zsh
curl -o $HOME/.zshrc ...

# Copy config files
if [[ ! -f .config.tar.gz ]]; then
    curl -o .config.tar.gz ...
fi

if [[ ! -d .config ]]; then
    tar -xvzf .config
fi

for i in .config/*; do
    rm -r "$HOME/$i"
    cp -r "$i" "$HOME/$i"
done

# Copy opt files
if [[ ! -f opt.tar.gz ]]; then
    curl -o .config.tar.gz ...
fi

if [[ ! -d opt ]]; then
    tar -xvzf opt.tar.gz
fi

mkdir -p "$HOME/.local/opt"
rm -r "$HOME/.local/opt"
cp -r opt "$HOME/.local/opt"

# Copy bin files
if [[ ! -f bin.tar.gz ]]; then
    curl -o .config.tar.gz ...
fi

if [[ ! -d bin ]]; then
    tar -xvzf bin.tar.gz
fi

mkdir -p "$HOME/.local/bin"
rm -r "$HOME/.local/bin"
cp -r bin "$HOME/.local/bin"
ln -sf "$HOME/.local/opt/theme/theme" "$HOME/.local/bin/theme"
ln -sf "$HOME/.local/opt/theme/wallpaper" "$HOME/.local/bin/wallpaper"

# Configure speech-dispatcher
spd-conf -ucn

# Enable services
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable ly@tty1.service

# Cleanup
cd $HOME
rm -r "$HOME/.tmp"

echo "Installation completed successfully"
