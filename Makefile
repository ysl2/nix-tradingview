.PHONY: all install uninstall verify clean help manual

# 默认目标
all: install

# 帮助信息
help:
	@echo "NixOS TradingView 安装脚本 Makefile"
	@echo ""
	@echo "可用命令:"
	@echo "  make install      - 一键安装 TradingView"
	@echo "  make uninstall    - 卸载 TradingView"
	@echo "  make verify       - 验证安装"
	@echo "  make clean        - 清理临时文件"
	@echo "  make manual       - 显示手动安装说明"
	@echo "  make help         - 显示此帮助信息"

# 一键安装
install:
	@echo "开始安装 TradingView..."
	@chmod +x setup.sh
	@./setup.sh

# 卸载
uninstall:
	@echo "开始卸载 TradingView..."
	@echo "停止服务..."
	@-systemctl --user stop tradingview.service 2>/dev/null || true
	@-systemctl --user disable tradingview.service 2>/dev/null || true
	@echo "从 Nix profile 移除..."
	@-nix profile remove nixpkgs#tradingview 2>/dev/null || echo "TradingView 未在 profile 中"
	@echo "删除配置文件..."
	@-rm -f ~/.config/systemd/user/tradingview.service
	@-rm -f ~/.local/bin/tradingview-wayland
	@-rm -f ~/.local/share/applications/tradingview.desktop
	@-rm -f ~/.local/share/icons/tradingview.png
	@echo "卸载完成"

# 验证安装
verify:
	@echo "验证 TradingView 安装..."
	@chmod +x scripts/verify-install.sh
	@./scripts/verify-install.sh

# 清理
clean:
	@echo "清理临时文件..."
	@find . -name "*.bak" -type f -delete
	@echo "清理完成"

# 手动安装说明
manual:
	@echo ""
	@echo "=========================================="
	@echo "  手动分步安装 TradingView"
	@echo "=========================================="
	@echo ""
	@cat manual/README.md
