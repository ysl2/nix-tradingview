# NixOS TradingView Installation Scripts

This project provides a complete set of scripts for installing and configuring TradingView desktop application on NixOS.

## Features

- ✅ Install TradingView via Nix (user-level)
- ✅ Configure HTTP/HTTPS proxy support
- ✅ Configure systemd service for auto-start
- ✅ Desktop launcher support (mod+d) via systemd
- ✅ Fix fcitx5 environment variables
- ⏸️ XWayland support planned for future (xwayland-satellite)

## Project Structure

```
~/Documents/nix-tradingview/
├── README.md              # This file
├── QUICKSTART.md          # Quick start guide
├── setup.sh               # One-click install script (recommended)
├── uninstall.sh           # One-click uninstall script
├── Makefile               # make command support
├── config/                # Configuration file templates
│   ├── README.md
│   ├── tradingview.service
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

### Method 3: Manual Installation

```bash
# Install TradingView
nix profile install nixpkgs#tradingview --impure

# Create and start service (see config/tradingview.service for template)
mkdir -p ~/.config/systemd/user
cp config/tradingview.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user start tradingview.service
```

## Requirements

- NixOS system
- `gnumake` (for Makefile method, install with `nix profile install nixpkgs#gnumake` or add to system packages)
- Proxy running on `127.0.0.1:20171` (modify `PROXY_PORT` variable in scripts if needed)
- fcitx5 input method framework (optional, for input method support)

## Configuration Details

### Proxy Settings

The scripts configure the following proxy environment variables:
- `http_proxy=http://127.0.0.1:20171`
- `https_proxy=http://127.0.0.1:20171`

To change the proxy port, edit the `PROXY_PORT` variable in `setup.sh`.

### System Configuration

The scripts create the following file:

1. **systemd service**: `~/.config/systemd/user/tradingview.service`

This service includes all necessary environment variables (proxy, Wayland, fcitx5) and manages the TradingView process.

## Usage

### Starting TradingView

#### Using systemd Service (Recommended)

```bash
systemctl --user start tradingview.service
```

#### Using Desktop Launcher (mod+d)

A desktop entry is provided for launching TradingView via your launcher (fuzzel, etc.). This will start the systemd service with all environment variables configured.

**Note**: Direct command execution (`tradingview`) does not include proxy and other environment variables. Always use systemd service or the desktop launcher.

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

### Method 1: One-Click Uninstall (Recommended)

```bash
cd ~/Documents/nix-tradingview
./uninstall.sh
```

### Method 2: Using Makefile

```bash
cd ~/Documents/nix-tradingview
make uninstall
```

### What Gets Removed

The uninstall script will:
- ✅ Stop and disable TradingView service
- ✅ Remove TradingView from Nix profile
- ✅ Remove configuration files
- ✅ Offer to remove .bashrc configuration (optional)
- ❌ **Preserve** user data in `~/.config/TradingView/`

### Manual Uninstall

If you prefer to uninstall manually:

```bash
# Stop and disable service
systemctl --user stop tradingview.service
systemctl --user disable tradingview.service

# Remove from Nix profile
nix profile remove nixpkgs#tradingview

# Remove configuration files
rm -f ~/.config/systemd/user/tradingview.service
rm -f ~/.local/share/applications/tradingview.desktop
rm -f ~/.local/bin/tradingview-launcher

# Remove user data (optional)
rm -rf ~/.config/TradingView
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

### v1.4.0 (2026-02-09)
- Added deep link protocol handler (`tradingview://`) for login
- Created wrapper script (`tradingview-launcher`) to handle both service start and URL arguments
- Fixed login redirect from web to desktop application
- Registered `x-scheme-handler/tradingview` with desktop database

### v1.3.0 (2026-02-09)
- Added desktop launcher support (mod+d) for fuzzel and other launchers
- Removed direct `tradingview` command from documentation (use systemd only)
- Updated installation to create desktop file that launches via systemd
- Updated uninstall script to remove desktop file

### v1.2.0 (2026-02-09)
- Added `gnumake` as a dependency (for Makefile method)
- Updated requirements documentation
- Tested all installation methods successfully

### v1.1.0 (2026-02-09)
- Simplified installation process (2 steps instead of 5)
- Removed desktop file and wrapper script (use systemctl only)
- Updated documentation to reflect systemctl-only approach
- Removed manual installation directory

### v1.0.0 (2026-02-09)
- Initial release
- Nix user-level installation support
- Proxy configuration
- Deep link configuration
- systemd service configuration
- fcitx5 environment variables fix

## Author

Created on 2026-02-09, based on actual installation experience.
