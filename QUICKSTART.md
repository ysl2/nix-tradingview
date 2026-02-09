# 快速开始指南

## 一键安装（推荐）

```bash
cd ~/Documents/nix-tradingview
./setup.sh
```

## 使用 Makefile

```bash
cd ~/Documents/nix-tradingview

# 安装
make install

# 验证
make verify

# 卸载
make uninstall
```

## 手动安装

```bash
cd ~/Documents/nix-tradingview/manual

# 逐步执行每个脚本
./step1-install.sh
./step2-proxy.sh
./step3-deep-link.sh
./step4-service.sh
./step5-bashrc.sh
```

## 验证安装

```bash
./scripts/verify-install.sh
```

## 配置要求

- **代理端口**: 20171（默认）
- **Wayland 合成器**: niri
- **输入法**: fcitx5

## 修改代理端口

如果你的代理不是 20171，需要编辑：

1. `setup.sh` - 修改 `PROXY_PORT` 变量
2. `manual/step2-proxy.sh` - 修改 `PROXY_PORT` 变量
3. `config/tradingview.service` - 修改代理地址
4. `config/tradingview-wayland` - 修改代理环境变量

## 故障排查

### 服务未启动

```bash
# 查看状态
systemctl --user status tradingview.service

# 查看日志
journalctl --user -u tradingview.service -f
```

### 深度链接不工作

```bash
# 检查配置
xdg-settings get default-url-scheme-handler tradingview

# 应该输出: tradingview.desktop
```

### 验证环境变量

```bash
# 检查运行中的进程
cat /proc/$(pgrep tradingview)/environ | tr '\0' '\n' | grep -E "(proxy|fcitx|WAYLAND)"
```

## 完成后

安装完成后，你应该能够：

1. ✓ 启动 TradingView
2. ✓ 使用代理访问网络
3. ✓ 通过深度链接登录
4. ✓ 服务自动重启

## 已知限制

- ⚠️ 输入法支持有限（Electron + Wayland 限制）
- 💡 建议使用浏览器版本以获得完整的 fcitx5 支持

## 需要帮助？

查看完整文档：`README.md`
