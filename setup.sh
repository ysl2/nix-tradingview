#!/usr/bin/env bash
#
# TradingView 一键安装脚本
# 用于 NixOS 系统
#
# 作者: Claude Code
# 日期: 2026-02-09
# 版本: 1.0.0
#

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
PROXY_PORT="20171"
PROXY_HOST="127.0.0.1"
TRADINGVIEW_PACKAGE="nixpkgs#tradingview"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 打印标题
print_header() {
    echo ""
    echo "=========================================="
    echo "  TradingView 安装脚本"
    echo "  NixOS 版本"
    echo "=========================================="
    echo ""
}

# 检查前置条件
check_prerequisites() {
    log_info "检查前置条件..."

    # 检查是否在 NixOS 上
    if [ ! -f /etc/NIXOS ]; then
        log_error "此脚本只能在 NixOS 上运行"
        exit 1
    fi

    # 检查 nix 命令
    if ! command -v nix &> /dev/null; then
        log_error "未找到 nix 命令"
        exit 1
    fi

    log_success "前置条件检查完成"
}

# 步骤 1: 安装 TradingView
install_tradingview() {
    log_info "步骤 1/5: 安装 TradingView..."

    # 设置代理环境变量
    export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
    export https_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
    export NIXPKGS_ALLOW_UNFREE=1

    # 安装 TradingView
    nix profile install "${TRADINGVIEW_PACKAGE}" --impure

    log_success "TradingView 安装完成"
}

# 步骤 2: 创建包装脚本
create_wrapper_script() {
    log_info "步骤 2/5: 创建 Wayland 包装脚本..."

    mkdir -p ~/.local/bin

    cat > ~/.local/bin/tradingview-wayland << 'EOF'
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

    chmod +x ~/.local/bin/tradingview-wayland

    log_success "包装脚本创建完成: ~/.local/bin/tradingview-wayland"
}

# 步骤 3: 配置 systemd 服务
create_systemd_service() {
    log_info "步骤 3/5: 配置 systemd 服务..."

    mkdir -p ~/.config/systemd/user

    cat > ~/.config/systemd/user/tradingview.service << EOF
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

    systemctl --user daemon-reload

    log_success "systemd 服务配置完成"
}

# 步骤 4: 配置深度链接
configure_deep_link() {
    log_info "步骤 4/5: 配置深度链接..."

    # 复制桌面文件
    mkdir -p ~/.local/share/applications
    cp /nix/store/*-tradingview-*/share/applications/tradingview.desktop ~/.local/share/applications/ 2>/dev/null || true

    # 更新桌面文件以使用包装脚本
    if [ -f ~/.local/share/applications/tradingview.desktop ]; then
        sed -i 's|^Exec=.*|Exec=/home/songliyu/.local/bin/tradingview-wayland %U|' ~/.local/share/applications/tradingview.desktop
    fi

    # 设置默认协议处理器
    xdg-settings set default-url-scheme-handler tradingview tradingview.desktop

    log_success "深度链接配置完成"
}

# 步骤 5: 更新 .bashrc
update_bashrc() {
    log_info "步骤 5/5: 更新 .bashrc..."

    BASHRC="$HOME/.bashrc"

    # 检查是否已经添加过
    if grep -q "TradingView fcitx5 fix" "$BASHRC" 2>/dev/null; then
        log_warning ".bashrc 已经包含 TradingView 配置，跳过"
        return
    fi

    # 备份 .bashrc
    cp "$BASHRC" "${BASHRC}.bak.$(date +%Y%m%d%H%M%S)"

    # 添加注释标记（供将来参考）
    cat >> "$BASHRC" << 'EOF'

# TradingView fcitx5 fix - 更新输入法环境变量为 fcitx5
# 注意：如果已经设置了 fcitx5，可以忽略此部分
EOF

    log_success ".bashrc 已更新（备份已创建）"
    log_info "注意：.bashrc 中的 fcitx5 配置已经在步骤 1-4 中通过 systemd 服务设置"
    log_info "如果需要全局 fcitx5 环境变量，请手动修改 .bashrc 中的输入法配置"
}

# 启动服务
start_service() {
    log_info "启动 TradingView 服务..."

    systemctl --user start tradingview.service

    log_success "TradingView 服务已启动"
}

# 打印总结
print_summary() {
    echo ""
    echo "=========================================="
    echo "  安装完成！"
    echo "=========================================="
    echo ""
    echo "TradingView 已成功安装并启动。"
    echo ""
    echo "服务管理命令："
    echo "  启动: systemctl --user start tradingview.service"
    echo "  停止: systemctl --user stop tradingview.service"
    echo "  重启: systemctl --user restart tradingview.service"
    echo "  状态: systemctl --user status tradingview.service"
    echo "  自启: systemctl --user enable tradingview.service"
    echo ""
    echo "直接运行:"
    echo "  tradingview"
    echo ""
    echo "验证安装:"
    echo "  ./scripts/verify-install.sh"
    echo ""
    echo "已知限制:"
    echo "  - 输入法支持有限（Electron + Wayland 限制）"
    echo "  - 建议使用浏览器版本以获得完整的 fcitx5 支持"
    echo ""
}

# 主函数
main() {
    print_header

    check_prerequisites
    install_tradingview
    create_wrapper_script
    create_systemd_service
    configure_deep_link
    update_bashrc
    start_service

    print_summary
}

# 运行主函数
main
