# NixOS TradingView 安装脚本

这个项目提供了一套完整的脚本，用于在 NixOS 上安装和配置 TradingView 桌面应用。

## 功能特性

- ✅ 通过 Nix 安装 TradingView（用户级）
- ✅ 配置 HTTP/HTTPS 代理支持
- ✅ 配置深度链接（tradingview:// 协议）
- ✅ 配置 systemd 服务自动启动
- ✅ 修复 fcitx5 环境变量配置
- ⏸️ XWayland 支持留待后续（计划使用 xwayland-satellite）

## 目录结构

```
~/Documents/nix-tradingview/
├── README.md              # 本文件
├── setup.sh               # 一键安装脚本（推荐）
├── Makefile               # make 命令支持
├── manual/                # 手动分步安装
│   ├── README.md          # 手动安装说明
│   ├── step1-install.sh   # 步骤1: 安装 TradingView
│   ├── step2-proxy.sh     # 步骤2: 配置代理
│   ├── step3-deep-link.sh # 步骤3: 配置深度链接
│   ├── step4-service.sh   # 步骤4: 配置服务
│   └── step5-bashrc.sh    # 步骤5: 更新 bashrc
├── config/                # 配置文件模板
│   ├── tradingview.service
│   ├── tradingview-wayland
│   └── nixos-fcitx5.patch
└── scripts/               # 辅助脚本
    └── verify-install.sh  # 验证安装
```

## 快速开始

### 方法 1: 一键安装（推荐）

```bash
cd ~/Documents/nix-tradingview
./setup.sh
```

### 方法 2: 使用 Makefile

```bash
cd ~/Documents/nix-tradingview
make install
```

### 方法 3: 手动分步安装

查看 `manual/README.md` 了解详细步骤。

## 前置要求

- NixOS 系统
- 代理服务运行在 `127.0.0.1:20171`（如需修改，编辑脚本中的 `PROXY_PORT` 变量）
- fcitx5 输入法框架

## 配置说明

### 代理设置

脚本会配置以下代理环境变量：
- `http_proxy=http://127.0.0.1:20171`
- `https_proxy=http://127.0.0.1:20171`

如需修改代理端口，编辑脚本中的 `PROXY_PORT` 变量。

### 系统配置

脚本会创建以下文件：

1. **systemd 服务**: `~/.config/systemd/user/tradingview.service`
2. **包装脚本**: `~/.local/bin/tradingview-wayland`
3. **桌面文件**: `~/.local/share/applications/tradingview.desktop`

## 使用方法

### 启动 TradingView

```bash
# 通过 systemd 启动（推荐）
systemctl --user start tradingview.service

# 或直接运行
tradingview
```

### 服务管理

```bash
# 启动
systemctl --user start tradingview.service

# 停止
systemctl --user stop tradingview.service

# 重启
systemctl --user restart tradingview.service

# 查看状态
systemctl --user status tradingview.service

# 开机自启
systemctl --user enable tradingview.service
```

## 验证安装

运行验证脚本：

```bash
./scripts/verify-install.sh
```

或使用 Makefile：

```bash
make verify
```

## 卸载

```bash
cd ~/Documents/nix-tradingview
make uninstall
```

或手动执行：

```bash
# 停止并禁用服务
systemctl --user stop tradingview.service
systemctl --user disable tradingview.service

# 删除 Nix profile 包
nix profile remove nixpkgs#tradingview

# 删除配置文件
rm -f ~/.config/systemd/user/tradingview.service
rm -f ~/.local/bin/tradingview-wayland
rm -f ~/.local/share/applications/tradingview.desktop
```

## 已知限制

### 输入法支持

**当前状态**: TradingView 桌面版在纯 Wayland 模式下对 fcitx5 的支持非常有限，这是 Electron 的限制。

**临时解决方案**:
- 使用浏览器版本访问 tradingview.com（对 fcitx5 支持完善）
- 或等待后续配置 xwayland-satellite 支持

**下一步计划**:
- 配置 xwayland-satellite 以提供 X11 后端支持
- 详见后续文档

## 故障排查

### TradingView 无法启动

1. 检查服务状态：
   ```bash
   systemctl --user status tradingview.service
   ```

2. 查看日志：
   ```bash
   journalctl --user -u tradingview.service -f
   ```

### 深度链接不工作

1. 检查协议处理器：
   ```bash
   xdg-settings get default-url-scheme-handler tradingview
   ```

2. 应该输出：`tradingview.desktop`

### 代理不生效

检查进程环境变量：
```bash
cat /proc/$(pgrep tradingview)/environ | tr '\0' '\n' | grep proxy
```

应该看到 `http_proxy` 和 `https_proxy` 设置。

## 贡献

如果你发现问题或有改进建议，欢迎提交 issue 或 pull request。

## 许可证

MIT License

## 更新日志

### v1.0.0 (2026-02-09)
- 初始版本
- 支持 Nix 用户级安装
- 配置代理支持
- 配置深度链接
- 配置 systemd 服务
- 修复 fcitx5 环境变量

## 作者

创建于 2026-02-09，基于实际安装经验。
