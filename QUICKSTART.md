# Quick Start Guide

## One-Click Install (Recommended)

```bash
cd ~/Documents/nix-tradingview
./setup.sh
```

## Using Makefile

```bash
cd ~/Documents/nix-tradingview

# Install
make install

# Verify
make verify

# Uninstall
make uninstall
```

## One-Click Uninstall

```bash
cd ~/Documents/nix-tradingview
./uninstall.sh
```

## Manual Installation

```bash
# Install TradingView
nix profile install nixpkgs#tradingview --impure

# Create and start service
mkdir -p ~/.config/systemd/user
cp config/tradingview.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user start tradingview.service
```

## Verify Installation

```bash
./scripts/verify-install.sh
```

## Configuration Requirements

- **Proxy Port**: 20171 (default)
- **Wayland Compositor**: niri
- **Input Method**: fcitx5

## Modifying Proxy Port

If your proxy is not on port 20171, edit:

1. `setup.sh` - modify `PROXY_PORT` variable
2. `config/tradingview.service` - modify proxy addresses

## Troubleshooting

### Service Not Running

```bash
# Check status
systemctl --user status tradingview.service

# View logs
journalctl --user -u tradingview.service -f
```

### Verify Environment Variables

```bash
# Check running process
cat /proc/$(pgrep tradingview)/environ | tr '\0' '\n' | grep -E "(proxy|fcitx|WAYLAND)"
```

## When Done

After installation, you should be able to:

1. ✓ Launch TradingView via systemctl
2. ✓ Use proxy for network access
3. ✓ Service auto-restart on failure

## Known Limitations

- ⚠️ Input method support limited (Electron + Wayland limitation)
- ⚠️ Desktop launcher not supported - use systemctl instead
- 💡 Recommend using browser version for full fcitx5 support

## Need Help?

See full documentation: `README.md`
