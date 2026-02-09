#!/usr/bin/env bash
#
# 步骤 1: 安装 TradingView
# 通过 Nix 包管理器安装 TradingView
#

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  步骤 1/5: 安装 TradingView${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# 检查是否已安装
if command -v tradingview &> /dev/null; then
    echo -e "${YELLOW}TradingView 已经安装，跳过此步骤${NC}"
    echo "当前版本: $(tradingview --version 2>/dev/null || echo 'unknown')"
    exit 0
fi

# 设置代理环境变量
echo "设置代理环境变量..."
export http_proxy="http://127.0.0.1:20171"
export https_proxy="http://127.0.0.1:20171"
export NIXPKGS_ALLOW_UNFREE=1

# 安装 TradingView
echo "正在安装 TradingView..."
echo "这可能需要 1-2 分钟，请耐心等待..."

nix profile install nixpkgs#tradingview --impure

echo ""
echo -e "${GREEN}✓ TradingView 安装完成！${NC}"
echo ""
echo "验证安装:"
tradingview --version
