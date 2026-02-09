#!/usr/bin/env bash
#
# Step 1: Install TradingView
# Install TradingView via Nix package manager
#

set -e

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  Step 1/5: Install TradingView${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Check if already installed
if command -v tradingview &> /dev/null; then
    echo -e "${YELLOW}TradingView already installed, skipping this step${NC}"
    echo "Current version: $(tradingview --version 2>/dev/null || echo 'unknown')"
    exit 0
fi

# Set proxy environment variables
echo "Setting proxy environment variables..."
export http_proxy="http://127.0.0.1:20171"
export https_proxy="http://127.0.0.1:20171"
export NIXPKGS_ALLOW_UNFREE=1

# Install TradingView
echo "Installing TradingView..."
echo "This may take 1-2 minutes, please wait..."

nix profile install nixpkgs#tradingview --impure

echo ""
echo -e "${GREEN}✓ TradingView installation completed!${NC}"
echo ""
echo "Verifying installation:"
tradingview --version
