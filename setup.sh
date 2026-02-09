#!/usr/bin/env bash
#
# TradingView One-Click Installation Script
# For NixOS systems
#
# Author: Claude Code
# Date: 2026-02-09
# Version: 1.0.0
#

set -e  # Exit on error

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration variables
PROXY_PORT="20171"
PROXY_HOST="127.0.0.1"
TRADINGVIEW_PACKAGE="nixpkgs#tradingview"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Print header
print_header() {
    echo ""
    echo "=========================================="
    echo "  TradingView Installation Script"
    echo "  NixOS Edition"
    echo "=========================================="
    echo ""
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check if running on NixOS
    if [ ! -f /etc/NIXOS ]; then
        log_error "This script can only run on NixOS"
        exit 1
    fi

    # Check nix command
    if ! command -v nix &> /dev/null; then
        log_error "nix command not found"
        exit 1
    fi

    log_success "Prerequisites check completed"
}

# Step 1: Install TradingView
install_tradingview() {
    log_info "Step 1/2: Installing TradingView..."

    # Set proxy environment variables
    export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
    export https_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
    export NIXPKGS_ALLOW_UNFREE=1

    # Install TradingView
    nix profile install "${TRADINGVIEW_PACKAGE}" --impure

    log_success "TradingView installation completed"
}

# Step 2: Configure systemd service
create_systemd_service() {
    log_info "Step 2/2: Configuring systemd service..."

    mkdir -p ~/.config/systemd/user

    cat > ~/.config/systemd/user/tradingview.service << EOF
[Unit]
Description=TradingView
After=niri.service
Requires=niri.service

[Service]
Type=simple
ExecStart=/home/songliyu/.nix-profile/bin/tradingview
Restart=on-failure
Environment=WAYLAND_DISPLAY=wayland-1
Environment=ELECTRON_OZONE_PLATFORM_HINT=wayland
Environment=http_proxy=http://${PROXY_HOST}:${PROXY_PORT}
Environment=https_proxy=http://${PROXY_HOST}:${PROXY_PORT}
Environment=HTTP_PROXY=http://${PROXY_HOST}:${PROXY_PORT}
Environment=HTTPS_PROXY=http://${PROXY_HOST}:${PROXY_PORT}
Environment=NO_PROXY=localhost,127.0.0.1
Environment=GTK_IM_MODULE=fcitx5
Environment=QT_IM_MODULE=fcitx5
Environment=XMODIFIERS=@im=fcitx5
Environment=SDL_IM_MODULE=fcitx5
Environment=INPUT_METHOD=fcitx5

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reload

    log_success "systemd service configuration completed"
}

# Start service
start_service() {
    log_info "Starting TradingView service..."

    systemctl --user start tradingview.service

    log_success "TradingView service started"
}

# Print summary
print_summary() {
    echo ""
    echo "=========================================="
    echo "  Installation Completed!"
    echo "=========================================="
    echo ""
    echo "TradingView has been successfully installed and started."
    echo ""
    echo "How to use TradingView:"
    echo "  Start:   systemctl --user start tradingview.service"
    echo "  Stop:    systemctl --user stop tradingview.service"
    echo "  Restart: systemctl --user restart tradingview.service"
    echo "  Status:  systemctl --user status tradingview.service"
    echo "  Enable:  systemctl --user enable tradingview.service"
    echo ""
    echo "Or run directly:"
    echo "  tradingview"
    echo ""
    echo "Verify Installation:"
    echo "  ./scripts/verify-install.sh"
    echo ""
    echo "Known Limitations:"
    echo "  - Limited input method support (Electron + Wayland limitation)"
    echo "  - Recommend using browser version for full fcitx5 support"
    echo ""
}

# Main function
main() {
    print_header

    check_prerequisites
    install_tradingview
    create_systemd_service
    start_service

    print_summary
}

# Run main function
main
