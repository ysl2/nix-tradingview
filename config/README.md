# Configuration File Templates

This directory contains configuration file templates required for TradingView installation.

## File Descriptions

### tradingview.service

systemd user service file for managing TradingView process.

**Installation location**: `~/.config/systemd/user/tradingview.service`

**Functions**:
- Define TradingView startup command
- Set environment variables (proxy, Wayland, fcitx5)
- Configure auto-restart

### tradingview-wayland

Wayland wrapper script to ensure TradingView uses correct backend and environment variables.

**Installation location**: `~/.local/bin/tradingview-wayland`

**Functions**:
- Set Wayland backend
- Configure proxy
- Configure fcitx5 input method

### nixos-fcitx5.patch

NixOS system configuration patch to fix system-level fcitx5 environment variables.

**Application method**:
```bash
cd ~/Documents/nix-tradingview
sudo patch -p1 < config/nixos-fcitx5.patch /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

**Note**: This patch requires sudo privileges and system rebuild.

## Customizing Configuration

### Modifying Proxy Port

If your proxy is not running on `127.0.0.1:20171`, you need to modify:

1. **tradingview.service**:
   - Modify all `http://127.0.0.1:20171` to your proxy address

2. **tradingview-wayland**:
   - Modify `export http_proxy` and `export https_proxy` variables

### Modifying Username

If your username is not `songliyu`, you need to modify:

1. **tradingview.service**:
   - Modify `ExecStart=/home/songliyu/.nix-profile/bin/tradingview`

2. **tradingview-wayland**:
   - Modify `exec /home/songliyu/.nix-profile/bin/tradingview`

## Manual Installation of Configuration Files

If you want to manually install these configuration files:

```bash
# Copy service file
cp config/tradingview.service ~/.config/systemd/user/
systemctl --user daemon-reload

# Copy wrapper script
cp config/tradingview-wayland ~/.local/bin/
chmod +x ~/.local/bin/tradingview-wayland

# Start service
systemctl --user start tradingview.service
```

## Notes

⚠️ **Important**: Installation scripts will automatically create and configure these files. Be careful when manually modifying these files and ensure the format is correct.
