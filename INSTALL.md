# Quick Installation Guide

## Option 1: Install Prebuilt Package (Recommended)

Download the latest `.deb` package from [GitHub Releases](https://github.com/shauryadotp/helium-browser-debian/releases).

```bash
# Install
sudo dpkg -i helium-browser-bin_0.5.8.1-1_amd64.deb
sudo apt-get install -f

# Launch
helium-browser
```

---

## Option 2: Build From Source

### Prerequisites

```bash
sudo apt-get update
sudo apt-get install debhelper devscripts build-essential
```

### Build the Package

```bash
cd helium-browser-debian
dpkg-buildpackage -us -uc -b
```

Build time: ~2-3 minutes (depending on system)

## Install the Package

```bash
cd ..
sudo dpkg -i helium-browser-bin_0.5.8.1-1_amd64.deb
sudo apt-get install -f
```

## Launch the Browser

```bash
helium-browser
```

Or use the application menu: look for "Helium Browser" under Internet/Web Browser.

## Custom Configuration (Optional)

### System-wide flags
```bash
sudo nano /etc/helium-browser-flags.conf
```

### User-specific flags
```bash
nano ~/.config/helium-browser-flags.conf
```

### Example flags
```
# Enable hardware video acceleration
--enable-features=VaapiVideoDecoder
--use-gl=desktop

# Enable dark mode
--force-dark-mode

# Disable GPU sandbox (if needed)
--disable-gpu-sandbox
```

### Using environment variable
```bash
export HELIUM_USER_FLAGS="--force-dark-mode --incognito"
helium-browser
```

## Uninstall

```bash
sudo apt-get remove helium-browser-bin
```

Or completely remove including config:
```bash
sudo apt-get purge helium-browser-bin
```

## Troubleshooting

### Missing dependencies
```bash
sudo apt-get install -f
```

### Check package contents
```bash
dpkg -L helium-browser-bin
```

### Verify installation
```bash
which helium-browser
ls -la /opt/helium-browser-bin/
```

### Run with debug output
```bash
helium-browser --enable-logging=stderr --v=1
```

## Support

- Upstream issues: https://github.com/imputnet/helium-linux/issues
- Debian packaging issues: File an issue in this repository
