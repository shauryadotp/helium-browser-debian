#!/bin/bash
# Script to check for new version from helium-linux GitHub releases
# SPDX-FileCopyrightText: 2025 Debian Package Contributors
# SPDX-License-Identifier: 0BSD

set -euo pipefail

echo "==> Fetching latest helium-linux release..."

# Get latest version from GitHub releases
# Note: We use HTML parsing instead of the GitHub API to avoid rate limiting issues
# The API has strict rate limits that could cause this workflow to fail
LATEST_VERSION=$(curl -fsSL "https://github.com/imputnet/helium-linux/releases/latest" | grep -oP 'releases/tag/\K[0-9.]+' | head -1)

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch latest version from GitHub"
    exit 1
fi

echo "==> Latest release version: $LATEST_VERSION"

# Get current local version
CURRENT_VERSION=$(grep -m1 '^pkgver=' aur.PKGBUILD | sed 's/pkgver=//')

echo "==> Current version: $CURRENT_VERSION"

# Compare versions
if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
    echo "==> New version detected: $LATEST_VERSION"
    
    # Download and calculate checksums for the new version
    TARBALL="helium-${LATEST_VERSION}-x86_64_linux.tar.xz"
    TARBALL_URL="https://github.com/imputnet/helium-linux/releases/download/${LATEST_VERSION}/${TARBALL}"
    DESKTOP_URL="https://raw.githubusercontent.com/imputnet/helium-linux/${LATEST_VERSION}/package/helium.desktop"
    
    # Create temporary directory for downloads
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TEMP_DIR"' EXIT
    
    echo "==> Downloading tarball to calculate checksum..."
    if ! wget -q "$TARBALL_URL" -O "${TEMP_DIR}/${TARBALL}"; then
        echo "Error: Could not download tarball from $TARBALL_URL"
        exit 1
    fi
    
    echo "==> Downloading desktop file to calculate checksum..."
    if ! wget -q "$DESKTOP_URL" -O "${TEMP_DIR}/helium.desktop"; then
        echo "Error: Could not download desktop file from $DESKTOP_URL"
        exit 1
    fi
    
    TARBALL_SHA256=$(sha256sum "${TEMP_DIR}/${TARBALL}" | awk '{print $1}')
    DESKTOP_SHA256=$(sha256sum "${TEMP_DIR}/helium.desktop" | awk '{print $1}')
    
    echo "==> Tarball SHA256: $TARBALL_SHA256"
    echo "==> Desktop SHA256: $DESKTOP_SHA256"
    
    # Set outputs for GitHub Actions
    if [ -n "${GITHUB_OUTPUT:-}" ]; then
        {
            echo "new_version=true"
            echo "version=$LATEST_VERSION"
            echo "tarball_sha256=$TARBALL_SHA256"
            echo "desktop_sha256=$DESKTOP_SHA256"
        } >> "$GITHUB_OUTPUT"
    fi
    
    exit 0
else
    echo "==> No new version available"
    
    if [ -n "${GITHUB_OUTPUT:-}" ]; then
        echo "new_version=false" >> "$GITHUB_OUTPUT"
    fi
    
    exit 0
fi
