#!/bin/bash
# Build script for Helium Browser Debian package
# SPDX-FileCopyrightText: 2025 Debian Package Contributors
# SPDX-License-Identifier: 0BSD

set -euo pipefail

_pkgname="helium"
_binaryname="helium-browser"
pkgver="0.5.8.1"
_tarball="${_pkgname}-${pkgver}-x86_64_linux.tar.xz"
pkgname="${_pkgname}-browser-bin"

echo "==> Downloading source files..."
if [ ! -f "${_tarball}" ]; then
    wget "https://github.com/imputnet/helium-linux/releases/download/${pkgver}/${_tarball}"
fi

if [ ! -f "helium.desktop" ]; then
    wget -O helium.desktop "https://raw.githubusercontent.com/imputnet/helium-linux/${pkgver}/package/helium.desktop"
fi

echo "==> Verifying checksums..."
echo "12997db0f2e00771eb28c3d75de8d84a46dacf6fee1075f5b9de3af9e41b829e  ${_tarball}" | sha256sum -c -
echo "cce8668c18d33077a585cb5d96522e5a02ae017a2baf800f8d7214ce6d05d3d2  helium.desktop" | sha256sum -c -

echo "==> Extracting tarball..."
tar -xf "${_tarball}"

echo "==> Preparing desktop file..."
sed -i \
  -e 's/Exec=chromium/Exec=helium-browser/' \
  -e 's/Name=Helium$/Name=Helium Browser/' \
  -e 's/Icon=helium/Icon=helium-browser/' \
  "helium.desktop"

echo "==> Installing files to debian package structure..."
# Copy browser files
cp -a "${_pkgname}-${pkgver}-x86_64_linux/"* "debian/opt/${pkgname}/"

# Disable user-local desktop generation in chrome-wrapper
sed -i 's/exists_desktop_file || generate_desktop_file/true/' \
  "debian/opt/${pkgname}/chrome-wrapper"

# Install desktop file
install -Dm644 "helium.desktop" \
  "debian/usr/share/applications/${_binaryname}.desktop"

# Install icons
install -Dm644 "debian/opt/${pkgname}/product_logo_256.png" \
  "debian/usr/share/pixmaps/${_binaryname}.png"
install -Dm644 "debian/opt/${pkgname}/product_logo_256.png" \
  "debian/usr/share/icons/hicolor/256x256/apps/${_binaryname}.png"

# Install wrapper script
cat > "debian/usr/bin/${_binaryname}" << 'EOF'
#!/bin/bash
# Fails on errors or unreadable commands
set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

SYS_CONF="/etc/helium-browser-flags.conf"
USR_CONF="${XDG_CONFIG_HOME}/helium-browser-flags.conf"

FLAGS=()

append_flags_file() {
  local file="$1"
  [[ -r "$file" ]] || return 0
  local line safe_line
  # Filter comments & blank lines
  while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*(#|$) ]] && continue
    # Sanitise: block command substitution; prevent $VAR and ~ expansion
    case "$line" in
      *'$('*|*'`'*)
        echo "Warning: ignoring unsafe line in $file: $line" >&2
        continue
        ;;
    esac
    # Disable globbing during eval
    set -f
    # Prevent $VAR and ~ expansion while allowing eval to parse quotes & escapes
    safe_line=${line//$/\\$}
    safe_line=${safe_line//~/\\~}
    eval "set -- $safe_line"
    # Enable globbing for rest of the script
    set +f
    for token in "$@"; do
      FLAGS+=("$token")
    done
  done < "$file"
}

append_flags_file "$SYS_CONF"
append_flags_file "$USR_CONF"

# Add environment var $HELIUM_USER_FLAGS
if [[ -n "${HELIUM_USER_FLAGS:-}" ]]; then
  # Split env contents on whitespace; users can quote if needed.
  read -r -a ENV_FLAGS <<< "$HELIUM_USER_FLAGS"
  FLAGS+=("${ENV_FLAGS[@]}")
fi

exec /opt/helium-browser-bin/chrome-wrapper "${FLAGS[@]}" "$@"
EOF

chmod 755 "debian/usr/bin/${_binaryname}"
chmod 755 "debian/DEBIAN/postinst"
chmod 755 "debian/DEBIAN/postrm"

echo "==> Calculating installed size..."
installed_size=$(du -sk debian | cut -f1)
echo "Installed-Size: ${installed_size}" >> debian/DEBIAN/control

echo "==> Building .deb package..."
dpkg-deb --build debian "${pkgname}_${pkgver}-1_amd64.deb"

echo "==> Package built successfully: ${pkgname}_${pkgver}-1_amd64.deb"
echo "==> To install: sudo dpkg -i ${pkgname}_${pkgver}-1_amd64.deb"
echo "==> To fix dependencies: sudo apt-get install -f"
