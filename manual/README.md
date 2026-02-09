# 手动分步安装 TradingView

这个目录包含手动分步安装的脚本，让你可以逐步控制安装过程。

## 步骤概览

1. **step1-install.sh** - 安装 TradingView（通过 Nix）
2. **step2-proxy.sh** - 配置代理设置
3. **step3-deep-link.sh** - 配置深度链接
4. **step4-service.sh** - 配置 systemd 服务
5. **step5-bashrc.sh** - 更新 .bashrc

## 使用方法

### 逐步执行

```bash
cd ~/Documents/nix-tradingview/manual

# 步骤 1: 安装 TradingView
chmod +x step1-install.sh
./step1-install.sh

# 步骤 2: 配置代理
chmod +x step2-proxy.sh
./step2-proxy.sh

# 步骤 3: 配置深度链接
chmod +x step3-deep-link.sh
./step3-deep-link.sh

# 步骤 4: 配置服务
chmod +x step4-service.sh
./step4-service.sh

# 步骤 5: 更新 bashrc
chmod +x step5-bashrc.sh
./step5-bashrc.sh
```

### 跳过某些步骤

如果某些步骤已经完成，可以跳过：

```bash
# 只执行步骤 4 和 5
./step4-service.sh
./step5-bashrc.sh
```

### 回滚步骤

每个脚本执行前会检查是否已经完成，所以可以安全地重复执行。

## 详细说明

### 步骤 1: 安装 TradingView

此脚本会：
- 设置 NIXPKGS_ALLOW_UNFREE 环境变量
- 通过 `nix profile install` 安装 TradingView
- 需要 Nix 包管理器

**执行时间**: 约 1-2 分钟（取决于网络速度）

### 步骤 2: 配置代理

此脚本会：
- 创建 Wayland 包装脚本 `~/.local/bin/tradingview-wayland`
- 配置代理环境变量（默认：127.0.0.1:20171）

**注意**: 如果你的代理端口不是 20171，需要编辑脚本。

### 步骤 3: 配置深度链接

此脚本会：
- 复制桌面文件到 `~/.local/share/applications/`
- 更新桌面文件以使用包装脚本
- 设置 tradingview:// 协议处理器

**效果**: 点击浏览器中的 "Grant Access" 按钮后，会自动打开 TradingView 应用。

### 步骤 4: 配置服务

此脚本会：
- 创建 systemd 服务文件 `~/.config/systemd/user/tradingview.service`
- 重新加载 systemd 配置
- 启动 TradingView 服务

**效果**: TradingView 会作为用户服务运行，可以自动重启。

### 步骤 5: 更新 .bashrc

此脚本会：
- 备份现有的 .bashrc
- 添加 fcitx5 环境变量注释

**注意**: 此步骤是可选的，因为 systemd 服务已经包含了所需的环境变量。

## 故障排查

### 步骤 1 失败

如果安装失败，检查：
- 网络连接是否正常
- 代理是否运行在正确的端口

### 步骤 3 失败

如果深度链接配置失败，检查：
- `xdg-settings` 命令是否可用
- 桌面文件是否正确复制

### 步骤 4 失败

如果服务启动失败，检查：
- niri 是否正在运行
- 日志：`journalctl --user -u tradingview.service -f`

## 验证安装

完成所有步骤后，运行验证脚本：

```bash
cd ..
./scripts/verify-install.sh
```

## 下一步

安装完成后，你可以：

1. 启动 TradingView: `tradingview`
2. 查看服务状态: `systemctl --user status tradingview.service`
3. 设置开机自启: `systemctl --user enable tradingview.service`
