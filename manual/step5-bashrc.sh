#!/usr/bin/env bash
#
# Step 5: Update .bashrc
# Add fcitx5 environment variable configuration
#

set -e

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BASHRC="$HOME/.bashrc"
MARKER="# TradingView fcitx5 fix"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  Step 5/5: Update .bashrc${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Check if .bashrc exists
if [ ! -f "$BASHRC" ]; then
    echo "Error: .bashrc does not exist"
    exit 1
fi

# Check if already added
if grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    echo -e "${YELLOW}.bashrc already contains TradingView configuration${NC}"
    echo ""
    echo "Current configuration:"
    grep -A 10 "$MARKER" "$BASHRC" || echo "(Configuration is empty)"
    echo ""
    echo "If you need to reconfigure, please manually edit .bashrc"
    exit 0
fi

# Backup .bashrc
BACKUP="${BASHRC}.bak.$(date +%Y%m%d%H%M%S)"
echo "Backing up .bashrc to $BACKUP..."
cp "$BASHRC" "$BACKUP"

# Add configuration
echo "Adding fcitx5 configuration to .bashrc..."
cat >> "$BASHRC" << 'EOF'

# TradingView fcitx5 fix - Update input method environment variables to fcitx5
# Note: systemd service already includes these environment variables
# This configuration is for global use
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export SDL_IM_MODULE=fcitx5
export INPUT_METHOD=fcitx5
EOF

echo ""
echo -e "${GREEN}✓ .bashrc updated!${NC}"
echo ""
echo "Backup file: $BACKUP"
echo ""
echo "Added configuration:"
echo "  GTK_IM_MODULE=fcitx5"
echo "  QT_IM_MODULE=fcitx5"
echo "  XMODIFIERS=@im=fcitx5"
echo "  SDL_IM_MODULE=fcitx5"
echo "  INPUT_METHOD=fcitx5"
echo ""
echo "Note: These environment variables are not required for TradingView,"
echo "as the systemd service already includes this configuration."
echo "These are for other applications."
echo ""
echo "Apply changes:"
echo "  source ~/.bashrc"
echo "Or re-login"
