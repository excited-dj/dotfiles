#!/bin/bash

set -e

echo "==> Cloning dotfiles..."
git clone https://github.com/exciteddj/dotfiles ~/dotfiles
cd ~/dotfiles

echo "==> Installing yay if not present..."
if ! command -v yay &>/dev/null; then
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~/dotfiles
fi

echo "==> Installing pacman packages..."
sudo pacman -S --noconfirm --needed \
    7zip amd-ucode base base-devel bibata-cursor-theme \
    bluez bluez-utils btop cava cmatrix cpupower dolphin \
    dunst efibootmgr fastfetch firefox flameshot git \
    gnome-control-center grim grub gst-plugin-pipewire htop \
    hyprland hyprlock hyprpaper intel-media-driver iwd kitty \
    kvantum libpulse libva-intel-driver libva-utils linux \
    linux-firmware nano neovim network-manager-applet \
    networkmanager noto-fonts noto-fonts-cjk noto-fonts-emoji \
    noto-fonts-extra nvidia-open nvidia-settings nvidia-utils \
    pavucontrol pipewire pipewire-alsa pipewire-jack \
    pipewire-pulse polkit-kde-agent qt5-wayland qt6-wayland \
    sddm slurp smartmontools steam sudo swaync swww \
    ttf-cascadia-code ttf-dejavu ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd ttf-liberation ttf-roboto \
    uwsm vim vlc vulkan-intel vulkan-nouveau vulkan-radeon \
    waybar wget wine wireless_tools wireplumber wlogout \
    wofi wpa_supplicant xdg-desktop-portal-hyprland \
    xdg-utils xf86-video-amdgpu xf86-video-ati \
    xf86-video-nouveau xorg-server xorg-xinit zram-generator zsh

echo "==> Installing AUR packages..."
yay -S --noconfirm --needed \
    ayugram-desktop-bin brave-bin pipes.sh sddm-sugar-candy-git \
    ttf-google-sans ttf-ms-fonts ttf-nerd-fonts-meta \
    ttf-nerd-fonts-symbols tty-clock

echo "==> Copying configs..."
mkdir -p ~/.config
for dir in hypr waybar kitty wofi dunst swaync wlogout cava btop; do
    if [ -d "$dir" ]; then
        cp -r "$dir" ~/.config/
        echo "  ✅ $dir"
    fi
done

if [ -f ".zshrc" ]; then
    cp .zshrc ~/.zshrc
    echo "  ✅ .zshrc"
fi

echo "==> Setting zsh as default shell..."
chsh -s $(which zsh)

echo ""
echo "✅ Done! Please reboot: sudo reboot"
