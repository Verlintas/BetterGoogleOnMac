#!/bin/bash
# 编译 Swift WKWebView 原生版 .app（不依赖 Chrome，通用二进制 arm64 + x86_64）
# Build native Swift WKWebView .app bundles (no Chrome needed, universal arm64 + x86_64)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
source "$ROOT_DIR/services.sh"

OUT_DIR="${1:-$ROOT_DIR/build/native_apps}"
ICON_DIR="$ROOT_DIR/build/icons"
TEMPLATE="$ROOT_DIR/swift/WebAppTemplate.swift"
MACOS_TARGET="macos12.0"

if ! command -v swiftc >/dev/null 2>&1; then
    echo "错误: 未找到 swiftc，请安装 Xcode 命令行工具 (xcode-select --install)"
    exit 1
fi

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

for entry in "${SERVICES[@]}"; do
    IFS='|' read -r name url domain slug _ _ _ <<< "$entry"
    app_dir="$OUT_DIR/$name.app"
    bundle_id="com.bettergoogle.native.$slug"
    binary="$name"
    src="$TMP_DIR/$slug.swift"
    mkdir -p "$app_dir/Contents/MacOS" "$app_dir/Contents/Resources"

    sed -e "s|{{APP_NAME}}|$name|g" -e "s|{{APP_URL}}|$url|g" "$TEMPLATE" > "$src"

    arm_bin="$TMP_DIR/$slug.arm"
    x86_bin="$TMP_DIR/$slug.x86"
    if swiftc -O -target "arm64-$MACOS_TARGET" "$src" -o "$arm_bin" -framework Cocoa -framework WebKit 2>"$TMP_DIR/$slug.arm.log" \
       && swiftc -O -target "x86_64-$MACOS_TARGET" "$src" -o "$x86_bin" -framework Cocoa -framework WebKit 2>"$TMP_DIR/$slug.x86.log" \
       && lipo -create "$arm_bin" "$x86_bin" -output "$app_dir/Contents/MacOS/$binary" 2>"$TMP_DIR/$slug.lipo.log"; then
        echo "编译成功 (通用二进制): $name"
    else
        echo "通用编译失败，尝试仅 arm64: $name"
        if ! swiftc -O -target "arm64-$MACOS_TARGET" "$src" -o "$app_dir/Contents/MacOS/$binary" -framework Cocoa -framework WebKit 2>"$TMP_DIR/$slug.fallback.log"; then
            echo "编译失败: $name"
            cat "$TMP_DIR/$slug.fallback.log"
            exit 1
        fi
        echo "编译成功 (arm64): $name"
    fi

    cat > "$app_dir/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleDisplayName</key>
    <string>$name</string>
    <key>CFBundleExecutable</key>
    <string>$binary</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>$bundle_id</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$name</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.productivity</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
EOF

    if [ -f "$ICON_DIR/$name.icns" ]; then
        cp "$ICON_DIR/$name.icns" "$app_dir/Contents/Resources/AppIcon.icns"
    fi
    printf 'APPL????' > "$app_dir/Contents/PkgInfo"

    if ! plutil -lint "$app_dir/Contents/Info.plist" >/dev/null; then
        echo "Info.plist 无效: $name"
        exit 1
    fi
    echo "生成: $name.app"
done

echo ""
echo "原生版应用已生成 → $OUT_DIR"
