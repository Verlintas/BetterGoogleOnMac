#!/bin/bash
# 将构建产物打包为 zip（用于 GitHub Release）
# Package build artifacts into zips (for GitHub Release)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
source "$ROOT_DIR/services.sh"

BUILD_DIR="$ROOT_DIR/build"
ZIP_DIR="$BUILD_DIR/zip"
mkdir -p "$ZIP_DIR"

CHROME_ZIP="$ZIP_DIR/BetterGoogleOnMac-Chrome-v$VERSION.zip"
NATIVE_ZIP="$ZIP_DIR/BetterGoogleOnMac-Native-v$VERSION.zip"

ditto -c -k --sequesterRsrc --keepParent "$BUILD_DIR/chrome_apps" "$CHROME_ZIP"
ditto -c -k --sequesterRsrc --keepParent "$BUILD_DIR/native_apps" "$NATIVE_ZIP"

echo "$CHROME_ZIP"
echo "$NATIVE_ZIP"
echo ""
echo "Release 包已生成 / Release packages ready"
