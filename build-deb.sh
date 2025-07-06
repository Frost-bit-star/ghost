#!/bin/bash
set -e

# Create debs folder if not exists
mkdir -p debs

# Clean previous build if exists
rm -f ghost.deb debs/ghost.deb

# Build the ghost.deb package from ghost directory
dpkg-deb --build ghost

# Move and rename the package to debs folder
mv ghost.deb debs/ghost.deb

echo "✅ ghost.deb built successfully and moved to debs/"
