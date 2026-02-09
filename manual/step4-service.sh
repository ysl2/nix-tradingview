#!/usr/bin/env bash
#
# 步骤 4: 配置 systemd 服务
# 创建并启动 TradingView systemd 用户服务
#

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 配置
SERVICE_FILE="$HOME/.config/systemd/user/tradingview.service"
PROXY_PORT="20171"
PROXY_HOST="127.0.0.1"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  步骤 4/5: 配置 systemd 服务${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# 创建目录
echo "创建 systemd 目录..."
mkdir -p ~/.config/systemd/user

# 检查服务是否已存在
if [ -f "$SERVICE_FILE" ]; then
    echo -e "${YELLOW}服务文件已存在，将覆盖${NC}"
    systemctl --user stop tradingview.service 2>/dev/null || true
    cp "$SERVICE_FILE" "${SERVICE_FILE}.bak.$(date +%Y%m%d%H%M%S)"
fi

# 创建服务文件
echo "创建 systemd 服务文件..."
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

# 重新加载 systemd
echo "重新加载 systemd 配置..."
systemctl --user daemon-reload

# 启动服务
echo "启动 TradingView 服务..."
systemctl --user start tradingview.service

# 等待服务启动
sleep 2

# 检查服务状态
if systemctl --user is-active --quiet tradingview.service; then
    echo ""
    echo -e "${GREEN}✓ 服务配置完成并已启动！${NC}"
    echo ""
    echo "服务管理命令:"
    echo "  启动:   systemctl --user start tradingview.service"
    echo "  停止:   systemctl --user stop tradingview.service"
    echo "  重启:   systemctl --user restart tradingview.service"
    echo "  状态:   systemctl --user status tradingview.service"
    echo "  日志:   journalctl --user -u tradingview.service -f"
    echo "  开机自启: systemctl --user enable tradingview.service"
    echo ""
    echo "当前状态:"
    systemctl --user status tradingview.service | head -5
else
    echo ""
    echo -e "${YELLOW}警告: 服务未正常运行${NC}"
    echo ""
    echo "查看日志以诊断问题:"
    echo "  journalctl --user -u tradingview.service -n 50"
fi
