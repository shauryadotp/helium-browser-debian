# Helium Browser - Debian Package

This repository contains the Debian packaging files for Helium Browser, ported from the Arch Linux AUR PKGBUILD.

## About Helium Browser

Helium is a private, fast, and honest web browser based on Chromium. It provides a privacy-focused browsing experience while maintaining compatibility with modern web standards.

## Download Prebuilt Package

See [GitHub Releases](https://github.com/shauryadotp/helium-browser-debian/releases) for prebuilt `.deb` packages.

## Building the Package

### Prerequisites

Install the required build tools:

```bash
sudo apt-get update
sudo apt-get install debhelper devscripts build-essential
```

### Build Instructions

1. Clone this repository or download the source:
   ```bash
   cd helium-browser-debian
   ```

2. Build the package:
   ```bash
   dpkg-buildpackage -us -uc -b
   ```

   Or using debuild:
   ```bash
   debuild -us -uc -b
   ```

3. The `.deb` package will be created in the parent directory:
   ```bash
   ls ../*.deb
   ```

### Installing the Package

```bash
sudo dpkg -i ../helium-browser-bin_*.deb
sudo apt-get install -f  # Install any missing dependencies
```

## Package Contents

- **Binary**: `/usr/bin/helium-browser` - Wrapper script to launch the browser
- **Application**: `/opt/helium-browser-bin/` - Main application files
- **Desktop Entry**: `/usr/share/applications/helium.desktop`
- **Icons**: `/usr/share/pixmaps/helium-browser.png` and `/usr/share/icons/hicolor/256x256/apps/helium-browser.png`

## Configuration

### Custom Flags

You can configure custom browser flags in two ways:

1. **System-wide**: Create `/etc/helium-browser-flags.conf`
2. **User-specific**: Create `~/.config/helium-browser-flags.conf`

Example flags file:
```
# Enable hardware acceleration
--enable-features=VaapiVideoDecoder
--use-gl=desktop

# Dark mode
--force-dark-mode
```

3. **Environment variable**: Set `HELIUM_USER_FLAGS`
   ```bash
   export HELIUM_USER_FLAGS="--force-dark-mode --enable-features=VaapiVideoDecoder"
   helium-browser
   ```

## Dependencies

The package automatically installs these required dependencies:
- libgtk-3-0
- libnss3
- libasound2
- xdg-utils
- libxss1
- libcups2
- libgcrypt20
- fonts-liberation
- systemd
- dbus
- libpulse0
- pciutils
- libva2
- libffi8 (or libffi7)
- desktop-file-utils
- hicolor-icon-theme

### Optional Dependencies

For enhanced functionality, consider installing:
- **pipewire**: WebRTC desktop sharing under Wayland
- **upower**: Battery Status API support
- **kdialog**: Native dialogs in Plasma
- **libgtk-4-1**: GTK4 support (may improve IME on Wayland)
- **gnome-keyring**: Password storage on GNOME/Xfce
- **kwalletmanager**: Password storage on KDE Plasma

## Uninstalling

```bash
sudo apt-get remove helium-browser-bin
```

To remove configuration files as well:
```bash
sudo apt-get purge helium-browser-bin
```

## Source

- **Upstream**: https://github.com/imputnet/helium-linux
- **Original AUR Package**: Maintained by Sam Sinclair and contributors
- **Version**: 0.5.8.1

## License

- **Helium Browser**: GPL-3.0-only
- **Debian packaging files**: 0BSD (Zero-Clause BSD)

## Credits

- Original PKGBUILD maintainer: Sam Sinclair
- Contributors: Pujan Modha, init_harsh, and Arch Linux Contributors
- Debian port: 2025
