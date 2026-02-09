# Changelog

All notable changes to this project will be documented in this file.

## [2026-02-09] - Migrate from manual niri startup to systemd service

### Summary
Migrated niri Wayland compositor from manual startup via `.bashrc` to systemd user service management. This enables proper dependency handling for the tradingview.service which depends on niri.service.

### Changes

#### Created: `~/.config/systemd/user/niri.service`
- New user-level systemd service for managing niri compositor
- Auto-restart on failure (with 1s delay)
- Includes necessary nvidia environment variables:
  - `LIBVA_DRIVER_NAME=nvidia`
  - `__GLX_VENDOR_LIBRARY_NAME=nvidia`
  - `WLR_RENDERER=vulkan`
  - `WLR_NO_HARDWARE_CURSORS=1`
- Binds to `graphical-session.target`

#### Modified: `~/.bashrc` (lines 140-160)
- Removed: Direct `exec niri` command
- Added: `systemctl --user import-environment` to pass environment variables to systemd user session
- Added: `systemctl --user start niri.service` to launch niri via systemd
- Changed: Shell now exits after starting niri.service (instead of exec replacement)

#### Updated: `~/.config/systemd/user/tradingview.service`
- Added: `After=niri.service` dependency
- Added: `Wants=niri.service` to ensure niri starts before tradingview

### Benefits
- Proper service dependency management
- Automatic restart of niri on crashes
- Consistent service management with tradingview
- Better integration with systemd ecosystem

### Testing
To verify the configuration after logging out and back in:
```bash
systemctl --user status niri.service
systemctl --user status tradingview.service
```

### System Context
- Display mode: multi-user.target (no display manager)
- Login: TTY1 black screen login
- Previous startup flow: `.bashrc` → `exec niri`
- New startup flow: `.bashrc` → `systemctl --user start niri.service`
