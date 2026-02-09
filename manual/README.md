# Manual Step-by-Step Installation

This directory contains scripts for manual step-by-step installation, giving you control over each step.

## Step Overview

1. **step1-install.sh** - Install TradingView (via Nix)
2. **step2-proxy.sh** - Configure proxy settings
3. **step3-deep-link.sh** - Configure deep links
4. **step4-service.sh** - Configure systemd service
5. **step5-bashrc.sh** - Update .bashrc

## Usage

### Execute Step by Step

```bash
cd ~/Documents/nix-tradingview/manual

# Step 1: Install TradingView
chmod +x step1-install.sh
./step1-install.sh

# Step 2: Configure proxy
chmod +x step2-proxy.sh
./step2-proxy.sh

# Step 3: Configure deep links
chmod +x step3-deep-link.sh
./step3-deep-link.sh

# Step 4: Configure service
chmod +x step4-service.sh
./step4-service.sh

# Step 5: Update bashrc
chmod +x step5-bashrc.sh
./step5-bashrc.sh
```

### Skip Certain Steps

If some steps are already completed, you can skip them:

```bash
# Only execute steps 4 and 5
./step4-service.sh
./step5-bashrc.sh
```

### Re-run Steps

Each script checks if the step is already completed before executing, so it's safe to re-run scripts.

## Detailed Steps

### Step 1: Install TradingView

This script will:
- Set NIXPKGS_ALLOW_UNFREE environment variable
- Install TradingView via `nix profile install`
- Requires Nix package manager

**Execution time**: About 1-2 minutes (depends on network speed)

### Step 2: Configure Proxy

This script will:
- Create Wayland wrapper script at `~/.local/bin/tradingview-wayland`
- Configure proxy environment variables (default: 127.0.0.1:20171)

**Note**: If your proxy port is not 20171, you need to edit the script.

### Step 3: Configure Deep Links

This script will:
- Copy desktop file to `~/.local/share/applications/`
- Update desktop file to use wrapper script
- Set tradingview:// protocol handler

**Effect**: When you click the "Grant Access" button in the browser, TradingView app will open automatically.

### Step 4: Configure Service

This script will:
- Create systemd service file at `~/.config/systemd/user/tradingview.service`
- Reload systemd configuration
- Start TradingView service

**Effect**: TradingView runs as a user service with auto-restart capability.

### Step 5: Update .bashrc

This script will:
- Backup existing .bashrc
- Add fcitx5 environment variable comments

**Note**: This step is optional as systemd service already includes required environment variables.

## Troubleshooting

### Step 1 Fails

If installation fails, check:
- Network connection is working
- Proxy is running on correct port

### Step 3 Fails

If deep link configuration fails, check:
- `xdg-settings` command is available
- Desktop file is copied correctly

### Step 4 Fails

If service fails to start, check:
- niri is running
- Logs: `journalctl --user -u tradingview.service -f`

## Verify Installation

After completing all steps, run the verification script:

```bash
cd ..
./scripts/verify-install.sh
```

## Next Steps

After installation, you can:

1. Start TradingView: `tradingview`
2. Check service status: `systemctl --user status tradingview.service`
3. Enable on login: `systemctl --user enable tradingview.service`
