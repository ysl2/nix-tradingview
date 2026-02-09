#!/usr/bin/env bash
#
# Step 4: Configure systemd Service
# Create and start TradingView systemd user service
#

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
SERVICE_FILE="$HOME/.config/systemd/user/tradingview.service"
PROXY_PORT="20171"
PROXY_HOST="127.0.0.1"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  Step 4/5: Configure systemd Service${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# Create directory
echo "Creating systemd directory..."
mkdir -p ~/.config/systemd/user

# Check if service already exists
if [ -f "$SERVICE_FILE" ]; then
    echo -e "${YELLOW}Service file already exists, will overwrite${NC}"
    systemctl --user stop tradingview.service 2>/dev/null || true
    cp "$SERVICE_FILE" "${SERVICE_FILE}.bak.$(date +%Y%m%d%H%M%S)"
fi

# Create service file
echo "Creating systemd service file..."
cat > "$SERVICE_FILE" << EOF
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
Environment=DISPLAY=
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

# Reload systemd
echo "Reloading systemd configuration..."
systemctl --user daemon-reload

# Start service
echo "Starting TradingView service..."
systemctl --user start tradingview.service

# Wait for service to start
sleep 2

# Check service status
if systemctl --user is-active --quiet tradingview.service; then
    echo ""
    echo -e "${GREEN}✓ Service configuration completed and started!${NC}"
    echo ""
    echo "Service management commands:"
    echo "  Start:   systemctl --user start tradingview.service"
    echo "  Stop:    systemctl --user stop tradingview.service"
    echo "  Restart: systemctl --user restart tradingview.service"
    echo "  Status:  systemctl --user status tradingview.service"
    echo "  Logs:    journalctl --user -u tradingview.service -f"
    echo "  Enable:  systemctl --user enable tradingview.service"
    echo ""
    echo "Current status:"
    systemctl --user status tradingview.service | head -5
else
    echo ""
    echo -e "${YELLOW}Warning: Service not running properly${NC}"
    echo ""
    echo "Check logs to diagnose issues:"
    echo "  journalctl --user -u tradingview.service -n 50"
fi
