#!/usr/bin/env bash
#
# TradingView Uninstallation Script
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
    echo "  TradingView Uninstallation Script"
    echo "  NixOS Edition"
    echo "=========================================="
    echo ""
}

# Confirmation prompt
confirm_uninstall() {
    echo -e "${YELLOW}WARNING: This will uninstall TradingView and remove the systemd service.${NC}"
    echo ""
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstallation cancelled."
        exit 0
    fi
}

# Stop and disable service
stop_service() {
    log_info "Stopping TradingView service..."

    if systemctl --user is-active --quiet tradingview.service 2>/dev/null; then
        systemctl --user stop tradingview.service
        log_success "Service stopped"
    else
        log_info "Service was not running"
    fi

    if systemctl --user is-enabled --quiet tradingview.service 2>/dev/null; then
        systemctl --user disable tradingview.service
        log_success "Service disabled"
    fi
}

# Remove from Nix profile
remove_from_nix() {
    log_info "Removing TradingView from Nix profile..."

    if nix profile list 2>/dev/null | grep -q "tradingview"; then
        nix profile remove nixpkgs#tradingview 2>/dev/null || log_warning "TradingView not in profile (may already be removed)"
        log_success "TradingView removed from Nix profile"
    else
        log_warning "TradingView not found in Nix profile"
    fi
}

# Remove configuration files
remove_config_files() {
    log_info "Removing configuration files..."

    SERVICE_FILE="$HOME/.config/systemd/user/tradingview.service"
    DESKTOP_FILE="$HOME/.local/share/applications/tradingview.desktop"
    LAUNCHER_SCRIPT="$HOME/.local/bin/tradingview-launcher"

    if [ -f "$SERVICE_FILE" ]; then
        rm -f "$SERVICE_FILE"
        log_success "Removed: $SERVICE_FILE"
    else
        log_info "Not found: $SERVICE_FILE"
    fi

    if [ -f "$DESKTOP_FILE" ]; then
        rm -f "$DESKTOP_FILE"
        log_success "Removed: $DESKTOP_FILE"
    else
        log_info "Not found: $DESKTOP_FILE"
    fi

    if [ -f "$LAUNCHER_SCRIPT" ]; then
        rm -f "$LAUNCHER_SCRIPT"
        log_success "Removed: $LAUNCHER_SCRIPT"
    else
        log_info "Not found: $LAUNCHER_SCRIPT"
    fi

    # Reload systemd
    systemctl --user daemon-reload 2>/dev/null || true
    log_success "systemd reloaded"
}

# Clean .bashrc (optional)
clean_bashrc() {
    log_info "Checking .bashrc for TradingView configuration..."

    BASHRC="$HOME/.bashrc"
    MARKER="# TradingView fcitx5 fix"

    if grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
        echo ""
        read -p "Remove TradingView configuration from .bashrc? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup .bashrc
            cp "$BASHRC" "${BASHRC}.bak.$(date +%Y%m%d%H%M%S)"

            # Remove TradingView section
            sed -i '/# TradingView fcitx5 fix/,/^$/d' "$BASHRC"
            log_success "Removed TradingView configuration from .bashrc"
        else
            log_info "Skipping .bashrc cleanup"
        fi
    else
        log_info "No TradingView configuration in .bashrc"
    fi
}

# Print summary
print_summary() {
    echo ""
    echo "=========================================="
    echo "  Uninstallation Completed!"
    echo "=========================================="
    echo ""
    echo "TradingView has been uninstalled."
    echo ""
    echo "Removed components:"
    echo "  - systemd service"
    echo "  - Nix profile package"
    echo ""
    echo "Note: User data in ~/.config/TradingView/ was preserved."
    echo "To remove user data, run:"
    echo "  rm -rf ~/.config/TradingView"
    echo ""
    log_success "Uninstallation completed successfully!"
}

# Main function
main() {
    print_header
    confirm_uninstall

    stop_service
    remove_from_nix
    remove_config_files
    clean_bashrc

    print_summary
}

# Run main function
main
