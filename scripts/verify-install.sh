#!/usr/bin/env bash
#
# Verify TradingView Installation
# Check all components are correctly installed
#

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
PASS=0
FAIL=0

# Test functions
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
echo -e "${BLUE}  TradingView Installation Verification${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""

# 1. Check TradingView executable
echo "Checking TradingView executable..."
if command -v tradingview &> /dev/null; then
    test_pass "tradingview command available"
    echo "  Location: $(which tradingview)"
    echo "  Version: $(tradingview --version 2>/dev/null || echo 'unknown')"
else
    test_fail "tradingview command not available"
fi
echo ""

# 2. Check wrapper script
echo "Checking wrapper script..."
WRAPPER="$HOME/.local/bin/tradingview-wayland"
if [ -f "$WRAPPER" ]; then
    test_pass "Wrapper script exists"
    if [ -x "$WRAPPER" ]; then
        test_pass "Wrapper script executable"
    else
        test_fail "Wrapper script not executable"
    fi
else
    test_fail "Wrapper script does not exist"
fi
echo ""

# 3. Check systemd service
echo "Checking systemd service..."
SERVICE="$HOME/.config/systemd/user/tradingview.service"
if [ -f "$SERVICE" ]; then
    test_pass "Service file exists"

    if systemctl --user is-active --quiet tradingview.service; then
        test_pass "Service is running"
    else
        test_fail "Service not running"
        test_info "Start service: systemctl --user start tradingview.service"
    fi
else
    test_fail "Service file does not exist"
fi
echo ""

# 4. Check deep link configuration
echo "Checking deep link configuration..."
HANDLER=$(xdg-settings get default-url-scheme-handler tradingview 2>/dev/null)
if [ "$HANDLER" = "tradingview.desktop" ]; then
    test_pass "Deep link configured"
else
    test_fail "Deep link not configured"
    test_info "Current: $HANDLER"
fi

if [ -f "$HOME/.local/share/applications/tradingview.desktop" ]; then
    test_pass "Desktop file exists"
else
    test_fail "Desktop file does not exist"
fi
echo ""

# 5. Check environment variables (from running process)
echo "Checking process environment variables..."
PID=$(pgrep -f tradingview | head -1)
if [ -n "$PID" ]; then
    test_pass "TradingView process running (PID: $PID)"

    # Check proxy
    if [ -f "/proc/$PID/environ" ]; then
        PROXY=$(cat "/proc/$PID/environ" | tr '\0' '\n' | grep "^http_proxy=")
        if [ -n "$PROXY" ]; then
            test_pass "Proxy configured: $PROXY"
        else
            test_fail "Proxy not configured"
        fi

        # Check Wayland
        WAYLAND=$(cat "/proc/$PID/environ" | tr '\0' '\n' | grep "^WAYLAND_DISPLAY=")
        if [ -n "$WAYLAND" ]; then
            test_pass "Wayland configured: $WAYLAND"
        else
            test_fail "Wayland not configured"
        fi

        # Check fcitx5
        FCITX=$(cat "/proc/$PID/environ" | tr '\0' '\n' | grep "^GTK_IM_MODULE=fcitx5")
        if [ -n "$FCITX" ]; then
            test_pass "fcitx5 configured: $FCITX"
        else
            test_fail "fcitx5 not configured"
        fi
    fi
else
    test_fail "TradingView process not running"
fi
echo ""

# 6. Check .bashrc
echo "Checking .bashrc configuration..."
if grep -q "TradingView fcitx5 fix" "$HOME/.bashrc" 2>/dev/null; then
    test_pass ".bashrc contains fcitx5 configuration"
else
    test_info ".bashrc does not contain fcitx5 configuration (optional)"
fi
echo ""

# Summary
echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  Verification Summary${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""
echo -e "${GREEN}Passed: $PASS${NC}"
echo -e "${RED}Failed: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}All checks passed! TradingView is correctly installed.${NC}"
    exit 0
else
    echo -e "${YELLOW}Some checks failed. Please see details above.${NC}"
    echo ""
    echo "Common issues:"
    echo "  1. Service not running: systemctl --user start tradingview.service"
    echo "  2. Deep link not configured: cd manual && ./step3-deep-link.sh"
    echo "  3. Proxy not configured: Check if proxy service is running on port 20171"
    exit 1
fi
