#!/usr/bin/env bash
#
# 步骤 3: 配置深度链接
# 配置 tradingview:// 协议处理器
#

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  步骤 3/5: 配置深度链接${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# 创建目录
echo "创建 applications 目录..."
mkdir -p ~/.local/share/applications

# 查找并复制桌面文件
echo "查找 TradingView 桌面文件..."
DESKTOP_SOURCE=$(find /nix/store -name "tradingview.desktop" 2>/dev/null | grep -v "/system-path/" | head -1)

if [ -z "$DESKTOP_SOURCE" ]; then
    echo "错误: 未找到 TradingView 桌面文件"
    echo "请先运行 step1-install.sh 安装 TradingView"
    exit 1
fi

echo "找到: $DESKTOP_SOURCE"

# 复制桌面文件
echo "复制桌面文件..."
cp "$DESKTOP_SOURCE" ~/.local/share/applications/tradingview.desktop

# 更新桌面文件以使用包装脚本
echo "更新桌面文件以使用包装脚本..."
sed -i 's|^Exec=.*|Exec=/home/songliyu/.local/bin/tradingview-wayland %U|' \
    ~/.local/share/applications/tradingview.desktop

# 设置默认协议处理器
echo "设置 tradingview:// 协议处理器..."
xdg-settings set default-url-scheme-handler tradingview tradingview.desktop

# 验证
HANDLER=$(xdg-settings get default-url-scheme-handler tradingview)
echo ""
echo -e "${GREEN}✓ 深度链接配置完成！${NC}"
echo ""
echo "配置详情:"
echo "  桌面文件: ~/.local/share/applications/tradingview.desktop"
echo "  协议处理器: $HANDLER"
echo ""
echo "测试深度链接:"
echo "  xdg-open 'tradingview://test'"
echo ""
echo "现在当你点击浏览器中的 'Grant Access' 按钮时，"
echo "TradingView 应用应该会自动打开。"
