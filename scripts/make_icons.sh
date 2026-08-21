#!/bin/bash
# 为各服务生成 .icns 图标：优先下载 Google favicon，失败则用本地 emoji 图标兜底
# Generate .icns icons: prefer Google favicon, fall back to locally generated emoji icons
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
source "$ROOT_DIR/services.sh"

ICON_DIR="$ROOT_DIR/build/icons"
GEN_SWIFT="$ROOT_DIR/swift/generate_icons.swift"
GEN_BIN="$ICON_DIR/src/gen_icons"
mkdir -p "$ICON_DIR/src"

if [ ! -x "$GEN_BIN" ]; then
    swiftc -O "$GEN_SWIFT" -o "$GEN_BIN" -framework AppKit 2>/dev/null || true
fi

for entry in "${SERVICES[@]}"; do
    IFS='|' read -r name url domain slug emoji color <<< "$entry"
    icns="$ICON_DIR/$name.icns"
    if [ -f "$icns" ]; then
        echo "图标已存在: $name"
        continue
    fi

    png="$ICON_DIR/src/$name.png"
    source="favicon"
    if ! curl -fsSL --max-time 15 "https://www.google.com/s2/favicons?domain=$domain&sz=256" -o "$png"; then
        source="emoji"
        if [ -x "$GEN_BIN" ]; then
            "$GEN_BIN" "$png" "$emoji" "$color"
        else
            echo "跳过图标: $name (无可用图标源)"
            continue
        fi
    fi

    iconset="$ICON_DIR/src/$name.iconset"
    rm -rf "$iconset"
    mkdir -p "$iconset"
    for size in 16 32 128 256 512; do
        sips -z "$size" "$size" "$png" --out "$iconset/icon_${size}x${size}.png" >/dev/null 2>&1
        sips -z "$((size * 2))" "$((size * 2))" "$png" --out "$iconset/icon_${size}x${size}@2x.png" >/dev/null 2>&1
    done
    if iconutil -c icns "$iconset" -o "$icns" 2>/dev/null; then
        echo "图标已生成 ($source): $name"
    else
        echo "跳过图标: $name (iconutil 失败)"
    fi
    rm -rf "$iconset" "$png"
done
