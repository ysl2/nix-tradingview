#!/usr/bin/env bash
#
# 验证 TradingView 安装
# 检查所有组件是否正确安装
#

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 计数器
PASS=0
FAIL=0

# 测试函数
test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

test_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  TradingView 安装验证${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# 1. 检查 TradingView 可执行文件
echo "检查 TradingView 可执行文件..."
if command -v tradingview &> /dev/null; then
    test_pass "tradingview 命令可用"
    echo "  位置: $(which tradingview)"
    echo "  版本: $(tradingview --version 2>/dev/null || echo 'unknown')"
else
    test_fail "tradingview 命令不可用"
fi
echo ""

# 2. 检查包装脚本
echo "检查包装脚本..."
WRAPPER="$HOME/.local/bin/tradingview-wayland"
if [ -f "$WRAPPER" ]; then
    test_pass "包装脚本存在"
    if [ -x "$WRAPPER" ]; then
        test_pass "包装脚本可执行"
    else
        test_fail "包装脚本不可执行"
    fi
else
    test_fail "包装脚本不存在"
fi
echo ""

# 3. 检查 systemd 服务
echo "检查 systemd 服务..."
SERVICE="$HOME/.config/systemd/user/tradingview.service"
if [ -f "$SERVICE" ]; then
    test_pass "服务文件存在"

    if systemctl --user is-active --quiet tradingview.service; then
        test_pass "服务正在运行"
    else
        test_fail "服务未运行"
        test_info "启动服务: systemctl --user start tradingview.service"
    fi
else
    test_fail "服务文件不存在"
fi
echo ""

# 4. 检查深度链接配置
echo "检查深度链接配置..."
HANDLER=$(xdg-settings get default-url-scheme-handler tradingview 2>/dev/null)
if [ "$HANDLER" = "tradingview.desktop" ]; then
    test_pass "深度链接已配置"
else
    test_fail "深度链接未配置"
    test_info "当前: $HANDLER"
fi

if [ -f "$HOME/.local/share/applications/tradingview.desktop" ]; then
    test_pass "桌面文件存在"
else
    test_fail "桌面文件不存在"
fi
echo ""

# 5. 检查环境变量（从运行中的进程）
echo "检查进程环境变量..."
PID=$(pgrep -f tradingview | head -1)
if [ -n "$PID" ]; then
    test_pass "TradingView 进程运行中 (PID: $PID)"

    # 检查代理
    if [ -f "/proc/$PID/environ" ]; then
        PROXY=$(cat "/proc/$PID/environ" | tr '\0' '\n' | grep "^http_proxy=")
        if [ -n "$PROXY" ]; then
            test_pass "代理已配置: $PROXY"
        else
            test_fail "代理未配置"
        fi

        # 检查 Wayland
        WAYLAND=$(cat "/proc/$PID/environ" | tr '\0' '\n' | grep "^WAYLAND_DISPLAY=")
        if [ -n "$WAYLAND" ]; then
            test_pass "Wayland 已配置: $WAYLAND"
        else
            test_fail "Wayland 未配置"
        fi

        # 检查 fcitx5
        FCITX=$(cat "/proc/$PID/environ" | tr '\0' '\n' | grep "^GTK_IM_MODULE=fcitx5")
        if [ -n "$FCITX" ]; then
            test_pass "fcitx5 已配置: $FCITX"
        else
            test_fail "fcitx5 未配置"
        fi
    fi
else
    test_fail "TradingView 进程未运行"
fi
echo ""

# 6. 检查 .bashrc
echo "检查 .bashrc 配置..."
if grep -q "TradingView fcitx5 fix" "$HOME/.bashrc" 2>/dev/null; then
    test_pass ".bashrc 已包含 fcitx5 配置"
else
    test_info ".bashrc 未包含 fcitx5 配置（可选）"
fi
echo ""

# 总结
echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  验证总结${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${RED}失败: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}所有检查通过！TradingView 已正确安装。${NC}"
    exit 0
else
    echo -e "${YELLOW}部分检查失败。请查看上面的详细信息。${NC}"
    echo ""
    echo "常见问题:"
    echo "  1. 服务未运行: systemctl --user start tradingview.service"
    echo "  2. 深度链接未配置: cd manual && ./step3-deep-link.sh"
    echo "  3. 代理未配置: 检查代理服务是否运行在端口 20171"
    exit 1
fi
