#!/bin/bash
# Script to update version in all relevant files
# SPDX-FileCopyrightText: 2025 Debian Package Contributors
# SPDX-License-Identifier: 0BSD

set -euo pipefail

if [ $# -ne 3 ]; then
    echo "Usage: $0 <version> <tarball_sha256> <desktop_sha256>"
    exit 1
fi

NEW_VERSION="$1"
TARBALL_SHA256="$2"
DESKTOP_SHA256="$3"

echo "==> Updating to version $NEW_VERSION"

# Get current version
CURRENT_VERSION=$(grep -m1 '^pkgver=' aur.PKGBUILD | sed 's/pkgver=//')

echo "==> Current version: $CURRENT_VERSION"
echo "==> New version: $NEW_VERSION"

# 1. Update aur.PKGBUILD
echo "==> Updating aur.PKGBUILD..."
sed -i "s/^pkgver=.*/pkgver=$NEW_VERSION/" aur.PKGBUILD

# Update sha256sums - need to handle multi-line array
# First, escape the forward slashes in checksums for sed
TARBALL_SHA256_ESCAPED="${TARBALL_SHA256//\//\\/}"
DESKTOP_SHA256_ESCAPED="${DESKTOP_SHA256//\//\\/}"

# Find and replace the checksums
sed -i "/^sha256sums_x86_64=/,/)/ {
    /^sha256sums_x86_64=/ {
        n
        s/'[^']*'/'$TARBALL_SHA256_ESCAPED'/
        n
        s/'[^']*'/'$DESKTOP_SHA256_ESCAPED'/
    }
}" aur.PKGBUILD

# 2. Update build.sh
echo "==> Updating build.sh..."
sed -i "s/^pkgver=\".*\"/pkgver=\"$NEW_VERSION\"/" build.sh
sed -i "s/^echo \".*  \${_tarball}\" | sha256sum -c -/echo \"$TARBALL_SHA256  \${_tarball}\" | sha256sum -c -/" build.sh
sed -i "s/^echo \".*  helium.desktop\" | sha256sum -c -/echo \"$DESKTOP_SHA256  helium.desktop\" | sha256sum -c -/" build.sh

# 3. Update debian/install
echo "==> Updating debian/install..."
sed -i "s|helium-.*-x86_64_linux/\* opt/helium-browser-bin/|helium-$NEW_VERSION-x86_64_linux/* opt/helium-browser-bin/|" debian/install

# 4. Update debian/changelog
echo "==> Updating debian/changelog..."
CHANGELOG_DATE=$(date -R)
cat > debian/changelog.new << EOF
helium-browser-bin ($NEW_VERSION-1) unstable; urgency=medium

  * New upstream release $NEW_VERSION
  * Automatically updated from AUR PKGBUILD

 -- github-actions[bot] <github-actions[bot]@users.noreply.github.com>  $CHANGELOG_DATE

EOF

cat debian/changelog >> debian/changelog.new
mv debian/changelog.new debian/changelog

# 5. Update README.md
echo "==> Updating README.md..."
sed -i "s/Version\*\*: .*/Version**: $NEW_VERSION/" README.md
sed -i "s/helium-browser-bin_.*_amd64.deb/helium-browser-bin_${NEW_VERSION}-1_amd64.deb/g" README.md

# 6. Update RELEASE_TEMPLATE.md
echo "==> Updating RELEASE_TEMPLATE.md..."
sed -i "s/# Helium Browser .* - Debian Package/# Helium Browser $NEW_VERSION-1 - Debian Package/" RELEASE_TEMPLATE.md
sed -i "s/helium-browser-bin_.*/helium-browser-bin_${NEW_VERSION}-1_amd64.deb\` (size will vary)/" RELEASE_TEMPLATE.md
sed -i "s|download/.*/helium-browser-bin|download/v$NEW_VERSION-1/helium-browser-bin|g" RELEASE_TEMPLATE.md

# 7. Update generate-checksums.sh
echo "==> Updating generate-checksums.sh..."
sed -i "s/helium-browser-bin_.*_amd64.deb/helium-browser-bin_${NEW_VERSION}-1_amd64.deb/g" generate-checksums.sh

echo "==> Version update complete!"
echo ""
echo "Updated files:"
echo "  - aur.PKGBUILD"
echo "  - build.sh"
echo "  - debian/install"
echo "  - debian/changelog"
echo "  - README.md"
echo "  - RELEASE_TEMPLATE.md"
echo "  - generate-checksums.sh"
