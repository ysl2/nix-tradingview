# 配置文件模板

这个目录包含 TradingView 安装所需的配置文件模板。

## 文件说明

### tradingview.service

systemd 用户服务文件，用于管理 TradingView 进程。

**安装位置**: `~/.config/systemd/user/tradingview.service`

**功能**:
- 定义 TradingView 启动命令
- 设置环境变量（代理、Wayland、fcitx5）
- 配置自动重启

### tradingview-wayland

Wayland 包装脚本，确保 TradingView 使用正确的后端和环境变量。

**安装位置**: `~/.local/bin/tradingview-wayland`

**功能**:
- 设置 Wayland 后端
- 配置代理
- 配置 fcitx5 输入法

### nixos-fcitx5.patch

NixOS 系统配置补丁，用于修复系统级别的 fcitx5 环境变量。

**应用方法**:
```bash
cd ~/Documents/nix-tradingview
sudo patch -p1 < config/nixos-fcitx5.patch /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

**注意**: 此补丁需要 sudo 权限和系统重建。

## 自定义配置

### 修改代理端口

如果你的代理不是运行在 `127.0.0.1:20171`，需要修改以下文件：

1. **tradingview.service**:
   - 修改所有 `http://127.0.0.1:20171` 为你的代理地址

2. **tradingview-wayland**:
   - 修改 `export http_proxy` 和 `export https_proxy` 变量

### 修改用户名

如果你的用户名不是 `songliyu`，需要修改：

1. **tradingview.service**:
   - 修改 `ExecStart=/home/songliyu/.nix-profile/bin/tradingview`

2. **tradingview-wayland**:
   - 修改 `exec /home/songliyu/.nix-profile/bin/tradingview`

## 手动安装配置文件

如果你想手动安装这些配置文件：

```bash
# 复制服务文件
cp config/tradingview.service ~/.config/systemd/user/
systemctl --user daemon-reload

# 复制包装脚本
cp config/tradingview-wayland ~/.local/bin/
chmod +x ~/.local/bin/tradingview-wayland

# 启动服务
systemctl --user start tradingview.service
```

## 注意事项

⚠️ **重要**: 安装脚本会自动创建和配置这些文件。手动修改这些文件时请小心，确保格式正确。
