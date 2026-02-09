.PHONY: all install uninstall verify clean help manual

# Default target
all: install

# Help information
help:
	@echo "NixOS TradingView Installation Script Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make install      - Install TradingView (one-click)"
	@echo "  make uninstall    - Uninstall TradingView"
	@echo "  make verify       - Verify installation"
	@echo "  make clean        - Clean temporary files"
	@echo "  make manual       - Show manual installation guide"
	@echo "  make help         - Show this help message"

# One-click install
install:
	@echo "Starting TradingView installation..."
	@chmod +x setup.sh
	@./setup.sh

# Uninstall
uninstall:
	@echo "Starting TradingView uninstallation..."
	@echo "Stopping service..."
	@-systemctl --user stop tradingview.service 2>/dev/null || true
	@-systemctl --user disable tradingview.service 2>/dev/null || true
	@echo "Removing from Nix profile..."
	@-nix profile remove nixpkgs#tradingview 2>/dev/null || echo "TradingView not in profile"
	@echo "Removing configuration files..."
	@-rm -f ~/.config/systemd/user/tradingview.service
	@-rm -f ~/.local/bin/tradingview-wayland
	@-rm -f ~/.local/share/applications/tradingview.desktop
	@-rm -f ~/.local/share/icons/tradingview.png
	@echo "Uninstallation completed"

# Verify installation
verify:
	@echo "Verifying TradingView installation..."
	@chmod +x scripts/verify-install.sh
	@./scripts/verify-install.sh

# Clean
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.bak" -type f -delete
	@echo "Clean completed"

# Manual installation guide
manual:
	@echo ""
	@echo "=========================================="
	@echo "  Manual Step-by-Step Installation"
	@echo "=========================================="
	@echo ""
	@cat manual/README.md
