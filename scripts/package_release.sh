#!/bin/bash
# 打包：每个服务独立 zip（Chrome 版 + 原生版）+ 两个合集 zip
# Package: per-service zips (Chrome + Native) plus two all-in-one zips
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
source "$ROOT_DIR/services.sh"

BUILD_DIR="$ROOT_DIR/build"
ZIP_DIR="$BUILD_DIR/zip"
APPS_DIR="$ZIP_DIR/apps"
mkdir -p "$APPS_DIR"
rm -f "$ZIP_DIR"/*.zip "$APPS_DIR"/*.zip

for entry in "${SERVICES[@]}"; do
    IFS='|' read -r name url domain slug _ _ <<< "$entry"
    slug_name="$(echo "$name" | tr ' ' '-')"
    variants=("Chromium|chromium_apps|" "Chrome|chrome_apps| (Chrome)" "Safari|native_apps| (Safari)")
    [ -d "$BUILD_DIR/chromium_apps_x64" ] && variants+=("Chromium-x64|chromium_apps_x64|")
    for variant in "${variants[@]}"; do
        label="${variant%%|*}"
        rest="${variant#*|}"
        folder="${rest%%|*}"
        suffix="${rest##*|}"
        app="$BUILD_DIR/$folder/$name$suffix.app"
        if [ ! -d "$app" ]; then
            echo "缺少应用，请先运行 scripts/create_all.sh: $app"
            exit 1
        fi
        zip="$APPS_DIR/$slug_name-$label-v$VERSION.zip"
        ditto -c -k --sequesterRsrc --keepParent "$app" "$zip"
        echo "$zip"
    done
done

CHROME_ZIP="$ZIP_DIR/BetterGoogleOnMac-Chrome-v$VERSION.zip"
NATIVE_ZIP="$ZIP_DIR/BetterGoogleOnMac-Safari-v$VERSION.zip"
CHROMIUM_ZIP="$ZIP_DIR/BetterGoogleOnMac-Chromium-v$VERSION.zip"
ditto -c -k --sequesterRsrc --keepParent "$BUILD_DIR/chrome_apps" "$CHROME_ZIP"
ditto -c -k --sequesterRsrc --keepParent "$BUILD_DIR/native_apps" "$NATIVE_ZIP"
ditto -c -k --sequesterRsrc --keepParent "$BUILD_DIR/chromium_apps" "$CHROMIUM_ZIP"
echo "$CHROME_ZIP"
echo "$NATIVE_ZIP"
echo "$CHROMIUM_ZIP"

echo ""
echo "Release 包已生成 / Release packages ready"
