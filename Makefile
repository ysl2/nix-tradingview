.PHONY: all install uninstall verify clean help

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
	@echo "  make help         - Show this help message"

# One-click install
install:
	@echo "Starting TradingView installation..."
	@chmod +x setup.sh
	@./setup.sh

# Uninstall
uninstall:
	@echo "Starting TradingView uninstallation..."
	@chmod +x uninstall.sh
	@./uninstall.sh

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
