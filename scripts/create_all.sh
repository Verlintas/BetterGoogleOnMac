#!/bin/bash
# 一键构建：图标 + Chrome 版 + 原生版，并安装到 ~/Applications/BetterGoogleOnMac
# One-click build: icons + Chrome apps + native apps, then install to ~/Applications/BetterGoogleOnMac
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$ROOT_DIR/build"
DEST="${1:-$HOME/Applications/BetterGoogleOnMac}"

bash "$SCRIPT_DIR/make_icons.sh"
bash "$SCRIPT_DIR/create_chrome_apps.sh"
bash "$SCRIPT_DIR/build_native_apps.sh"

rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$BUILD_DIR/chrome_apps/" "$DEST/"
cp -R "$BUILD_DIR/native_apps/" "$DEST/"

echo ""
echo "全部完成！应用已安装到: $DEST"
echo "All done! Apps installed to: $DEST"
