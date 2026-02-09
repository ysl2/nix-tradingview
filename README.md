# NixOS TradingView Installation Scripts

This project provides a complete set of scripts for installing and configuring TradingView desktop application on NixOS.

## Features

- ✅ Install TradingView via Nix (user-level)
- ✅ Configure HTTP/HTTPS proxy support
- ✅ Configure deep links (tradingview:// protocol)
- ✅ Configure systemd service for auto-start
- ✅ Fix fcitx5 environment variables
- ⏸️ XWayland support planned for future (xwayland-satellite)

## Project Structure

```
~/Documents/nix-tradingview/
├── README.md              # This file
├── QUICKSTART.md          # Quick start guide
├── setup.sh               # One-click install script (recommended)
├── Makefile               # make command support
├── manual/                # Manual step-by-step installation
│   ├── README.md          # Manual installation guide
│   ├── step1-install.sh   # Step 1: Install TradingView
│   ├── step2-proxy.sh     # Step 2: Configure proxy
│   ├── step3-deep-link.sh # Step 3: Configure deep links
│   ├── step4-service.sh   # Step 4: Configure service
│   └── step5-bashrc.sh    # Step 5: Update bashrc
├── config/                # Configuration file templates
│   ├── README.md
│   ├── tradingview.service
│   ├── tradingview-wayland
│   └── nixos-fcitx5.patch
└── scripts/               # Utility scripts
    └── verify-install.sh  # Verify installation
```

## Quick Start

### Method 1: One-click Install (Recommended)

```bash
cd ~/Documents/nix-tradingview
./setup.sh
```

### Method 2: Using Makefile

```bash
cd ~/Documents/nix-tradingview
make install
```

### Method 3: Manual Step-by-Step Installation

See `manual/README.md` for detailed steps.

## Requirements

- NixOS system
- Proxy running on `127.0.0.1:20171` (modify `PROXY_PORT` variable in scripts if needed)
- fcitx5 input method framework

## Configuration Details

### Proxy Settings

The scripts configure the following proxy environment variables:
- `http_proxy=http://127.0.0.1:20171`
- `https_proxy=http://127.0.0.1:20171`

To change the proxy port, edit the `PROXY_PORT` variable in the scripts.

### System Configuration

The scripts create the following files:

1. **systemd service**: `~/.config/systemd/user/tradingview.service`
2. **Wrapper script**: `~/.local/bin/tradingview-wayland`
3. **Desktop file**: `~/.local/share/applications/tradingview.desktop`

## Usage

### Starting TradingView

```bash
# Start via systemd (recommended)
systemctl --user start tradingview.service

# Or run directly
tradingview
```

### Service Management

```bash
# Start
systemctl --user start tradingview.service

# Stop
systemctl --user stop tradingview.service

# Restart
systemctl --user restart tradingview.service

# Check status
systemctl --user status tradingview.service

# Enable on login
systemctl --user enable tradingview.service
```

## Verification

Run the verification script:

```bash
./scripts/verify-install.sh
```

Or use Makefile:

```bash
make verify
```

## Uninstall

```bash
cd ~/Documents/nix-tradingview
make uninstall
```

Or manually:

```bash
# Stop and disable service
systemctl --user stop tradingview.service
systemctl --user disable tradingview.service

# Remove from Nix profile
nix profile remove nixpkgs#tradingview

# Remove configuration files
rm -f ~/.config/systemd/user/tradingview.service
rm -f ~/.local/bin/tradingview-wayland
rm -f ~/.local/share/applications/tradingview.desktop
```

## Known Limitations

### Input Method Support

**Current Status**: TradingView desktop has very limited fcitx5 support in pure Wayland mode. This is an Electron limitation.

**Workaround**:
- Use browser version at tradingview.com (has full fcitx5 support)
- Wait for future xwayland-satellite configuration

**Next Steps**:
- Configure xwayland-satellite for X11 backend support
- See future documentation

## Troubleshooting

### TradingView Won't Start

1. Check service status:
   ```bash
   systemctl --user status tradingview.service
   ```

2. View logs:
   ```bash
   journalctl --user -u tradingview.service -f
   ```

### Deep Links Not Working

1. Check protocol handler:
   ```bash
   xdg-settings get default-url-scheme-handler tradingview
   ```

2. Should output: `tradingview.desktop`

### Proxy Not Working

Check process environment variables:
```bash
cat /proc/$(pgrep tradingview)/environ | tr '\0' '\n' | grep proxy
```

You should see `http_proxy` and `https_proxy` settings.

## Contributing

If you find issues or have suggestions for improvement, feel free to submit an issue or pull request.

## License

MIT License

## Changelog

### v1.0.0 (2026-02-09)
- Initial release
- Nix user-level installation support
- Proxy configuration
- Deep link configuration
- systemd service configuration
- fcitx5 environment variables fix

## Author

Created on 2026-02-09, based on actual installation experience.
