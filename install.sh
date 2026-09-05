#!/usr/bin/env bash

set -euo pipefail

version="1.0"

# Update and install packages
sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
    alacritty \
    amberol \
    apostrophe \
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
    plymouth \
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
    ttf-cascadia-code \
    ttf-cascadia-code-nerd \
    ttf-dejavu \
    ttf-dejavu-nerd \
    ttf-fira-code \
    ttf-fira-sans \
    ttf-firacode-nerd \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-material-symbols-variable \
    ttf-noto-nerd \
    ttf-roboto \
    ttf-ubuntu-font-family \
    ttf-ubuntu-mono-nerd \
    ttf-ubuntu-nerd \
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

flatpak install --noninteractive flathub org.gnome.Showtime

# Configure plymouth
sudo sed -i '/^HOOKS=/ { /plymouth/! s/\bsystemd\b/& plymouth/; }' /etc/mkinitcpio.conf
sudo mkinitcpio -P

# Install themes
mkdir -p "$HOME/.tmp"
cd "$HOME/.tmp"

if ! pacman -Qi yaru-theme &>/dev/null; then
    if [[ ! -f yaru-theme.tar.gz ]]; then
        curl -fL "https://github.com/pikriawan/arch-linux-install-script/releases/download/v${version}/yaru-theme.tar.gz" -o yaru-theme.tar.gz
    fi

    if [[ ! -d yaru-theme ]]; then
        tar -xvzf yaru-theme.tar.gz
    fi

    cd yaru-theme
    makepkg -si --needed --noconfirm
    cd ..
fi

if ! pacman -Qi bibata-modern-classic-cursor-theme &>/dev/null; then
    if [[ ! -f bibata-modern-classic-cursor-theme.tar.gz ]]; then
        curl -fL "https://github.com/pikriawan/arch-linux-install-script/releases/download/v${version}/bibata-modern-classic-cursor-theme.tar.gz" -o bibata-modern-classic-cursor-theme.tar.gz
    fi

    if [[ ! -d bibata-modern-classic-cursor-theme ]]; then
        tar -xvzf bibata-modern-classic-cursor-theme.tar.gz
    fi

    cd bibata-modern-classic-cursor-theme
    makepkg -si --needed --noconfirm
    cd ..
fi

# Install yay
if ! pacman -Qi yay &>/dev/null; then
    if [[ ! -d yay ]]; then
        git clone https://aur.archlinux.org/yay.git
    fi

    cd yay
    makepkg -si --needed --noconfirm
    cd ..
fi

# Configure npm
mkdir -p "$HOME/.npm-global"
npm set prefix="$HOME/.npm-global"

# Configure zsh
if [[ ! -d "$HOME/.zsh" ]]; then
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi

sudo chsh -s /usr/bin/zsh "$USER"
curl -fL "https://github.com/pikriawan/arch-linux-install-script/releases/download/v${version}/default.zshrc" -o "$HOME/.zshrc"

# Copy config files
if [[ ! -f .config.tar.gz ]]; then
    curl -fL "https://github.com/pikriawan/arch-linux-install-script/releases/download/v${version}/default.config.tar.gz" -o .config.tar.gz
fi

if [[ ! -d .config ]]; then
    tar -xvzf .config.tar.gz
fi

for i in .config/*; do
    rm -rf "$HOME/$i"
    cp -r $i "$HOME/$i"
done

# Copy opt files
if [[ ! -f opt.tar.gz ]]; then
    curl -fL "https://github.com/pikriawan/arch-linux-install-script/releases/download/v${version}/opt.tar.gz" -o opt.tar.gz
fi

if [[ ! -d opt ]]; then
    tar -xvzf opt.tar.gz
fi

rm -rf "$HOME/.local/opt"
cp -r opt "$HOME/.local/opt"

# Copy bin files
if [[ ! -f bin.tar.gz ]]; then
    curl -fL "https://github.com/pikriawan/arch-linux-install-script/releases/download/v${version}/bin.tar.gz" -o bin.tar.gz
fi

if [[ ! -d bin ]]; then
    tar -xvzf bin.tar.gz
fi

rm -rf "$HOME/.local/bin"
cp -r bin "$HOME/.local/bin"
ln -sf "$HOME/.local/opt/theme-manager/theme-manager" "$HOME/.local/bin/theme-manager"

# Initialize theme
bash -c "$HOME/.local/bin/theme-manager init"

# Configure speech-dispatcher
spd-conf -ucn

# Enable services
sudo systemctl enable bluetooth.service
sudo systemctl enable ly@tty1.service

# Cleanup
cd "$HOME"
rm -rf "$HOME/.tmp"

echo "Installation completed successfully"
echo "Please restart your computer"
