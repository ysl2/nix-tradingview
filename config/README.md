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

2. **setup.sh**:
   - Modify `PROXY_PORT` variable

### Modifying Username

If your username is not `songliyu`, you need to modify:

1. **tradingview.service**:
   - Modify `ExecStart=/home/songliyu/.nix-profile/bin/tradingview`

2. **setup.sh**:
   - Modify the `ExecStart` line in the `create_systemd_service()` function

## Manual Installation of Configuration Files

If you want to manually install these configuration files:

```bash
# Copy service file
cp config/tradingview.service ~/.config/systemd/user/
systemctl --user daemon-reload

# Start service
systemctl --user start tradingview.service
```

## Notes

⚠️ **Important**: Installation scripts will automatically create and configure these files. Be careful when manually modifying these files and ensure the format is correct.
