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

## Manual Installation

```bash
cd ~/Documents/nix-tradingview/manual

# Execute each script step by step
./step1-install.sh
./step2-proxy.sh
./step3-deep-link.sh
./step4-service.sh
./step5-bashrc.sh
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
2. `manual/step2-proxy.sh` - modify `PROXY_PORT` variable
3. `config/tradingview.service` - modify proxy addresses
4. `config/tradingview-wayland` - modify proxy environment variables

## Troubleshooting

### Service Not Running

```bash
# Check status
systemctl --user status tradingview.service

# View logs
journalctl --user -u tradingview.service -f
```

### Deep Links Not Working

```bash
# Check configuration
xdg-settings get default-url-scheme-handler tradingview

# Should output: tradingview.desktop
```

### Verify Environment Variables

```bash
# Check running process
cat /proc/$(pgrep tradingview)/environ | tr '\0' '\n' | grep -E "(proxy|fcitx|WAYLAND)"
```

## When Done

After installation, you should be able to:

1. ✓ Launch TradingView
2. ✓ Use proxy for network access
3. ✓ Log in via deep links
4. ✓ Service auto-restart

## Known Limitations

- ⚠️ Input method support limited (Electron + Wayland limitation)
- 💡 Recommend using browser version for full fcitx5 support

## Need Help?

See full documentation: `README.md`
