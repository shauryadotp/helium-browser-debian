#!/bin/bash
# Generate checksums for the built packages

echo "=== Helium Browser Package Checksums ==="
echo ""

if [ -f "../helium-browser-bin_0.5.8.1-1_amd64.deb" ]; then
    echo "Main Package:"
    echo "-------------"
    echo "File: helium-browser-bin_0.5.8.1-1_amd64.deb"
    echo -n "Size: "
    ls -lh "../helium-browser-bin_0.5.8.1-1_amd64.deb" | awk '{print $5}'
    echo -n "SHA256: "
    sha256sum "../helium-browser-bin_0.5.8.1-1_amd64.deb" | awk '{print $1}'
    echo -n "MD5: "
    md5sum "../helium-browser-bin_0.5.8.1-1_amd64.deb" | awk '{print $1}'
    echo ""
else
    echo "❌ Main package not found. Build it first with: dpkg-buildpackage -us -uc -b"
    echo ""
fi

if [ -f "../helium-browser-bin-dbgsym_0.5.8.1-1_amd64.deb" ]; then
    echo "Debug Symbols Package:"
    echo "---------------------"
    echo "File: helium-browser-bin-dbgsym_0.5.8.1-1_amd64.deb"
    echo -n "Size: "
    ls -lh "../helium-browser-bin-dbgsym_0.5.8.1-1_amd64.deb" | awk '{print $5}'
    echo -n "SHA256: "
    sha256sum "../helium-browser-bin-dbgsym_0.5.8.1-1_amd64.deb" | awk '{print $1}'
    echo -n "MD5: "
    md5sum "../helium-browser-bin-dbgsym_0.5.8.1-1_amd64.deb" | awk '{print $1}'
    echo ""
fi

echo "=== Copy these checksums to DOWNLOAD.md after uploading to Fastly ==="
