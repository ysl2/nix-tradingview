#!/usr/bin/env bash
#
# Step 2: Configure Proxy Settings
# Create Wayland wrapper script with proxy and fcitx5 support
#

set -e

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
PROXY_PORT="20171"
PROXY_HOST="127.0.0.1"
WRAPPER_SCRIPT="$HOME/.local/bin/tradingview-wayland"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  Step 2/5: Configure Proxy Settings${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Create directory
echo "Creating ~/.local/bin directory..."
mkdir -p ~/.local/bin

# Check if already exists
if [ -f "$WRAPPER_SCRIPT" ]; then
    echo -e "${YELLOW}Wrapper script already exists, will overwrite${NC}"
    cp "$WRAPPER_SCRIPT" "${WRAPPER_SCRIPT}.bak.$(date +%Y%m%d%H%M%S)"
fi

# Create wrapper script
echo "Creating Wayland wrapper script..."
cat > "$WRAPPER_SCRIPT" << 'EOF'
#!/usr/bin/env bash
# TradingView wrapper for Wayland with fcitx5 support
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export DISPLAY=""
export http_proxy=http://127.0.0.1:20171
export https_proxy=http://127.0.0.1:20171
# fcitx5 input method support
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export SDL_IM_MODULE=fcitx5
export INPUT_METHOD=fcitx5
exec /home/songliyu/.nix-profile/bin/tradingview "$@"
EOF

# Set execute permission
chmod +x "$WRAPPER_SCRIPT"

echo ""
echo -e "${GREEN}✓ Proxy configuration completed!${NC}"
echo ""
echo "Created file:"
echo "  $WRAPPER_SCRIPT"
echo ""
echo "Configuration:"
echo "  HTTP proxy:  http://${PROXY_HOST}:${PROXY_PORT}"
echo "  HTTPS proxy: http://${PROXY_HOST}:${PROXY_PORT}"
echo "  Wayland backend: enabled"
echo "  fcitx5 support: enabled"
echo ""
echo "Note: If your proxy port is not ${PROXY_PORT}, please edit this script"
