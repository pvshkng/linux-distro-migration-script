#!/bin/bash

set -e

SUCCESS_LOG=()
ERROR_LOG=()

log_success() {
    SUCCESS_LOG+=("$1")
}

log_error() {
    ERROR_LOG+=("$1")
}

echo "=== Linux Migration Setup Script ==="
echo ""

read -p "Enter your Git username: " GIT_USERNAME
read -p "Enter your Git email: " GIT_EMAIL

echo ""
echo "Starting installation process..."
echo ""

if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
    UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    UPDATE_CMD="sudo dnf update -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    UPDATE_CMD="sudo pacman -Syu --noconfirm"
else
    echo "Unsupported package manager"
    exit 1
fi

echo "Updating system..."
if $UPDATE_CMD &> /dev/null; then
    log_success "System update"
else
    log_error "System update"
fi

if ! command -v git &> /dev/null; then
    echo "Installing git..."
    if $INSTALL_CMD git &> /dev/null; then
        log_success "Git installation"
    else
        log_error "Git installation"
    fi
else
    log_success "Git (already installed)"
fi

if command -v git &> /dev/null; then
    echo "Configuring git..."
    if git config --global user.name "$GIT_USERNAME" && git config --global user.email "$GIT_EMAIL"; then
        log_success "Git configuration"
    else
        log_error "Git configuration"
    fi
fi

echo "Installing Node.js via nvm..."
if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh 2>/dev/null | bash &> /dev/null; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if nvm install 24 &> /dev/null; then
        log_success "Node.js installation"
    else
        log_error "Node.js installation"
    fi
else
    log_error "NVM installation"
fi

echo "Installing Go..."
GO_VERSION="1.23.5"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
if curl -sL "https://go.dev/dl/${GO_TAR}" -o "/tmp/${GO_TAR}" && \
   sudo rm -rf /usr/local/go && \
   sudo tar -C /usr/local -xzf "/tmp/${GO_TAR}" &> /dev/null; then
    if ! grep -q "/usr/local/go/bin" "$HOME/.bashrc"; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
    fi
    export PATH=$PATH:/usr/local/go/bin
    log_success "Go installation"
else
    log_error "Go installation"
fi

echo "Installing Python 3.14..."
if [ "$PKG_MANAGER" = "apt" ]; then
    if sudo add-apt-repository ppa:deadsnakes/ppa -y &> /dev/null && \
       $INSTALL_CMD python3.14 python3.14-venv python3.14-dev &> /dev/null; then
        log_success "Python 3.14 installation"
    else
        log_error "Python 3.14 installation"
    fi
else
    if $INSTALL_CMD python3 python3-pip &> /dev/null; then
        log_success "Python installation (latest available)"
    else
        log_error "Python installation"
    fi
fi

echo "Installing Bun..."
if curl -fsSL https://bun.com/install 2>/dev/null | bash &> /dev/null; then
    log_success "Bun installation"
else
    log_error "Bun installation"
fi

echo "Installing Rust..."
if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs 2>/dev/null | sh -s -- -y &> /dev/null; then
    source "$HOME/.cargo/env"
    log_success "Rust installation"
else
    log_error "Rust installation"
fi

echo "Installing Zed..."
if curl -f https://zed.dev/install.sh 2>/dev/null | sh &> /dev/null; then
    log_success "Zed installation"
else
    log_error "Zed installation"
fi

echo "Installing GitHub CLI..."
if $INSTALL_CMD gh &> /dev/null; then
    log_success "GitHub CLI installation"
else
    log_error "GitHub CLI installation"
fi

if ! command -v flatpak &> /dev/null; then
    echo "Installing Flatpak..."
    if $INSTALL_CMD flatpak &> /dev/null; then
        if [ "$PKG_MANAGER" = "apt" ]; then
            $INSTALL_CMD gnome-software-plugin-flatpak &> /dev/null
        fi
        sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /dev/null
        log_success "Flatpak installation"
    else
        log_error "Flatpak installation"
    fi
fi

echo "Installing Zen Browser..."
if flatpak install -y flathub io.github.zen_browser.zen &> /dev/null; then
    log_success "Zen Browser installation"
else
    log_error "Zen Browser installation"
fi

echo "Installing Obsidian..."
if flatpak install -y flathub md.obsidian.Obsidian &> /dev/null; then
    log_success "Obsidian installation"
else
    log_error "Obsidian installation"
fi

echo "Installing Heroic Launcher..."
if flatpak install -y flathub com.heroicgameslauncher.hgl &> /dev/null; then
    log_success "Heroic Launcher installation"
else
    log_error "Heroic Launcher installation"
fi

echo "Installing qBittorrent..."
if flatpak install -y flathub org.qbittorrent.qBittorrent &> /dev/null; then
    log_success "qBittorrent installation"
else
    log_error "qBittorrent installation"
fi

echo "Installing Stremio..."
if flatpak install -y flathub com.stremio.Stremio &> /dev/null; then
    log_success "Stremio installation"
else
    log_error "Stremio installation"
fi

echo "Installing Collabora Office..."
if flatpak install -y flathub com.collaboraoffice.Office &> /dev/null; then
    log_success "Collabora Office installation"
else
    log_error "Collabora Office installation"
fi

echo "Installing VLC..."
if flatpak install -y flathub org.videolan.VLC &> /dev/null; then
    log_success "VLC installation"
else
    log_error "VLC installation"
fi

echo "Installing ntfs-3g..."
if $INSTALL_CMD ntfs-3g &> /dev/null; then
    log_success "ntfs-3g installation"
else
    log_error "ntfs-3g installation"
fi

echo "Installing neofetch..."
if $INSTALL_CMD neofetch &> /dev/null; then
    log_success "neofetch installation"
else
    log_error "neofetch installation"
fi

echo "Installing Steam..."
if [ "$PKG_MANAGER" = "apt" ]; then
    if curl -sL https://cdn.fastly.steamstatic.com/client/installer/steam.deb -o /tmp/steam.deb && \
       sudo dpkg -i /tmp/steam.deb &> /dev/null; then
        sudo apt-get install -f -y &> /dev/null
        log_success "Steam installation"
    else
        log_error "Steam installation"
    fi
else
    if $INSTALL_CMD steam &> /dev/null; then
        log_success "Steam installation"
    else
        log_error "Steam installation"
    fi
fi

echo "Installing essential utilities..."
ESSENTIALS="curl wget build-essential cmake vim htop tmux zip unzip"
if $INSTALL_CMD $ESSENTIALS &> /dev/null; then
    log_success "Essential utilities installation"
else
    log_error "Essential utilities installation"
fi

echo ""
echo "============================================"
echo "           INSTALLATION SUMMARY"
echo "============================================"
echo ""

if [ ${#SUCCESS_LOG[@]} -gt 0 ]; then
    echo "✓ SUCCESSFUL INSTALLATIONS (${#SUCCESS_LOG[@]}):"
    for item in "${SUCCESS_LOG[@]}"; do
        echo "  ✓ $item"
    done
    echo ""
fi

if [ ${#ERROR_LOG[@]} -gt 0 ]; then
    echo "✗ FAILED INSTALLATIONS (${#ERROR_LOG[@]}):"
    for item in "${ERROR_LOG[@]}"; do
        echo "  ✗ $item"
    done
    echo ""
fi

echo "Success: ${#SUCCESS_LOG[@]}"
echo "Errors: ${#ERROR_LOG[@]}"
