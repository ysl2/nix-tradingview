#!/usr/bin/env bash
#
# 步骤 5: 更新 .bashrc
# 添加 fcitx5 环境变量配置
#

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BASHRC="$HOME/.bashrc"
MARKER="# TradingView fcitx5 fix"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  步骤 5/5: 更新 .bashrc${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# 检查 .bashrc 是否存在
if [ ! -f "$BASHRC" ]; then
    echo "错误: .bashrc 不存在"
    exit 1
fi

# 检查是否已经添加过
if grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    echo -e "${YELLOW}.bashrc 已经包含 TradingView 配置${NC}"
    echo ""
    echo "当前配置:"
    grep -A 10 "$MARKER" "$BASHRC" || echo "(配置为空)"
    echo ""
    echo "如果需要重新配置，请手动编辑 .bashrc"
    exit 0
fi

# 备份 .bashrc
BACKUP="${BASHRC}.bak.$(date +%Y%m%d%H%M%S)"
echo "备份 .bashrc 到 $BACKUP..."
cp "$BASHRC" "$BACKUP"

# 添加配置
echo "添加 fcitx5 配置到 .bashrc..."
cat >> "$BASHRC" << 'EOF'

# TradingView fcitx5 fix - 更新输入法环境变量为 fcitx5
# 注意：systemd 服务已包含这些环境变量
# 此配置供全局使用
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export SDL_IM_MODULE=fcitx5
export INPUT_METHOD=fcitx5
EOF

echo ""
echo -e "${GREEN}✓ .bashrc 已更新！${NC}"
echo ""
echo "备份文件: $BACKUP"
echo ""
echo "添加的配置:"
echo "  GTK_IM_MODULE=fcitx5"
echo "  QT_IM_MODULE=fcitx5"
echo "  XMODIFIERS=@im=fcitx5"
echo "  SDL_IM_MODULE=fcitx5"
echo "  INPUT_METHOD=fcitx5"
echo ""
echo "注意: 这些环境变量对 TradingView 不是必需的，"
echo "因为 systemd 服务已经包含了这些配置。"
echo "这些配置供其他应用使用。"
echo ""
echo "使配置生效:"
echo "  source ~/.bashrc"
echo "或重新登录"
