#!/usr/bin/env bash
#
# Step 3: Configure Deep Links
# Configure tradingview:// protocol handler
#

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  Step 3/5: Configure Deep Links${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Create directory
echo "Creating applications directory..."
mkdir -p ~/.local/share/applications

# Find and copy desktop file
echo "Finding TradingView desktop file..."
DESKTOP_SOURCE=$(find /nix/store -name "tradingview.desktop" 2>/dev/null | grep -v "/system-path/" | head -1)

if [ -z "$DESKTOP_SOURCE" ]; then
    echo "Error: TradingView desktop file not found"
    echo "Please run step1-install.sh first to install TradingView"
    exit 1
fi

echo "Found: $DESKTOP_SOURCE"

# Copy desktop file
echo "Copying desktop file..."
cp "$DESKTOP_SOURCE" ~/.local/share/applications/tradingview.desktop

# Update desktop file to use wrapper script
echo "Updating desktop file to use wrapper script..."
sed -i 's|^Exec=.*|Exec=/home/songliyu/.local/bin/tradingview-wayland %U|' \
    ~/.local/share/applications/tradingview.desktop

# Set default protocol handler
echo "Setting tradingview:// protocol handler..."
xdg-settings set default-url-scheme-handler tradingview tradingview.desktop

# Verify
HANDLER=$(xdg-settings get default-url-scheme-handler tradingview)
echo ""
echo -e "${GREEN}✓ Deep link configuration completed!${NC}"
echo ""
echo "Configuration details:"
echo "  Desktop file: ~/.local/share/applications/tradingview.desktop"
echo "  Protocol handler: $HANDLER"
echo ""
echo "Test deep link:"
echo "  xdg-open 'tradingview://test'"
echo ""
echo "Now when you click the 'Grant Access' button in the browser,"
echo "the TradingView app should open automatically."
