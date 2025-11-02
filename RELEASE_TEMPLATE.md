# Helium Browser 0.5.8.1-1 - Debian Package

Private, fast, and honest web browser based on Chromium, packaged for Debian/Ubuntu systems.

## 📦 Downloads

- **Main Package:** `helium-browser-bin_0.5.8.1-1_amd64.deb` (127 MB)
- **Debug Symbols:** `helium-browser-bin-dbgsym_0.5.8.1-1_amd64.deb` (19 MB) - Optional
- **Checksums:** `checksums.txt`

## ✅ Checksums

### Main Package
- **SHA256:** `072888e59494fa6197877dc108c07dc3c53c93d08c56df62b5ab3d3582206868`
- **MD5:** `635c12c8cccd997c755b2dc839c41957`

### Debug Symbols
- **SHA256:** `7da305e88b98f45fe06857060ccb579f36d6a1379e4659423d3ab4d930bd3b7a`
- **MD5:** `76c26a12daa2324da2c41c5c9712c1fa`

## 🚀 Quick Install

```bash
# Download
wget https://github.com/shauryadotp/helium-browser-debian/releases/download/v0.5.8.1-1/helium-browser-bin_0.5.8.1-1_amd64.deb

# Verify (optional but recommended)
sha256sum helium-browser-bin_0.5.8.1-1_amd64.deb

# Install
sudo dpkg -i helium-browser-bin_0.5.8.1-1_amd64.deb
sudo apt-get install -f

# Launch
helium-browser
```

## 📋 What's Included

- ✅ Complete Debian package from Arch Linux AUR PKGBUILD
- ✅ All dependencies properly mapped
- ✅ Desktop integration (menu entry + icons)
- ✅ Secure wrapper script with custom flags support
- ✅ Post-install/removal scripts

## 🖥️ Compatibility

- Debian 11+ (Bullseye, Bookworm)
- Ubuntu 20.04 LTS, 22.04 LTS, 24.04 LTS
- Linux Mint 20+, 21+, 22+
- Pop!_OS 20.04+, 22.04+
- Other Debian-based distributions

## 📦 Package Details

- **Package:** helium-browser-bin
- **Version:** 0.5.8.1-1
- **Architecture:** amd64
- **Maintainer:** Shaurya <shaurya@shauryadotp.me>
- **Installed Size:** ~491 MB

## 🔧 Configuration (Optional)

### Custom Browser Flags

Create flag files to customize browser behavior:

**System-wide:** `/etc/helium-browser-flags.conf`
**User-specific:** `~/.config/helium-browser-flags.conf`

Example:
```
# Enable hardware acceleration
--enable-features=VaapiVideoDecoder
--use-gl=desktop

# Dark mode
--force-dark-mode
```

Or use environment variable:
```bash
export HELIUM_USER_FLAGS="--force-dark-mode"
helium-browser
```

## 🛠️ Build From Source

See the [README.md](https://github.com/shauryadotp/helium-browser-debian#building-the-package) for build instructions.

## 📞 Support

- **Issues:** https://github.com/shauryadotp/helium-browser-debian/issues
- **Upstream:** https://github.com/imputnet/helium-linux
- **Maintainer:** Shaurya <shaurya@shauryadotp.me>

## 📝 Credits

- **Original PKGBUILD:** Sam Sinclair, Pujan Modha, init_harsh, Arch Linux Contributors
- **Debian Port:** Shaurya <shaurya@shauryadotp.me>
- **Upstream:** Helium Browser Developers

---

**First Release!** 🎉
