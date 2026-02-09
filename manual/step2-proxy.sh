#!/usr/bin/env bash
#
# 步骤 2: 配置代理设置
# 创建 Wayland 包装脚本，配置代理和 fcitx5
#

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
PROXY_PORT="20171"
PROXY_HOST="127.0.0.1"
WRAPPER_SCRIPT="$HOME/.local/bin/tradingview-wayland"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  步骤 2/5: 配置代理设置${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# 创建目录
echo "创建 ~/.local/bin 目录..."
mkdir -p ~/.local/bin

# 检查是否已存在
if [ -f "$WRAPPER_SCRIPT" ]; then
    echo -e "${YELLOW}包装脚本已存在，将覆盖${NC}"
    cp "$WRAPPER_SCRIPT" "${WRAPPER_SCRIPT}.bak.$(date +%Y%m%d%H%M%S)"
fi

# 创建包装脚本
echo "创建 Wayland 包装脚本..."
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

# 设置执行权限
chmod +x "$WRAPPER_SCRIPT"

echo ""
echo -e "${GREEN}✓ 代理配置完成！${NC}"
echo ""
echo "创建的文件:"
echo "  $WRAPPER_SCRIPT"
echo ""
echo "配置:"
echo "  HTTP 代理: http://${PROXY_HOST}:${PROXY_PORT}"
echo "  HTTPS 代理: http://${PROXY_HOST}:${PROXY_PORT}"
echo "  Wayland 后端: 启用"
echo "  fcitx5 支持: 启用"
echo ""
echo "注意: 如果你的代理端口不是 ${PROXY_PORT}，请编辑此脚本"
