#!/bin/bash
# 构建 Chromium 版（Electron 自包含，剥离后每应用独立打包）
# Build Chromium edition: self-contained stripped Electron apps, one per service
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
source "$ROOT_DIR/services.sh"

OUT_DIR="${1:-$ROOT_DIR/build/chromium_apps}"
ICON_DIR="$ROOT_DIR/build/icons"
EL_DIR="$ROOT_DIR/build/electron"
EL_ZIP="$EL_DIR/electron.zip"
TEMPLATE="$EL_DIR/template.app"
EL_VERSION="43.4.1"
APP_TEMPLATE_DIR="$ROOT_DIR/chromium/app"
ASAR_PACK="$SCRIPT_DIR/asar_pack.js"

if ! command -v node >/dev/null 2>&1; then
    echo "错误: 需要 Node.js (node)"
    exit 1
fi

# ---- 1. 下载并解包 Electron（未缓存时）----
if [ ! -f "$EL_ZIP" ]; then
    echo "下载 Electron v$EL_VERSION (npmmirror 镜像)..."
    mkdir -p "$EL_DIR"
    curl -fsSL --max-time 600 -o "$EL_ZIP" \
        "https://npmmirror.com/mirrors/electron/$EL_VERSION/electron-v$EL_VERSION-darwin-arm64.zip"
fi

# ---- 2. 制作剥离模板（一次性）----
if [ ! -d "$TEMPLATE" ]; then
    echo "解包并剥离 Electron..."
    ditto -x -k "$EL_ZIP" "$EL_DIR/unpacked"
    mkdir -p "$EL_DIR"
    cp -c -R "$EL_DIR/unpacked/Electron.app" "$TEMPLATE"

    C="$TEMPLATE/Contents"
    FR="$C/Frameworks/Electron Framework.framework/Versions/A"
    # 只保留中英文语言包（顶层 + 框架内部，框架内部占了 ~60MB）
    find "$C/Resources" -maxdepth 1 -name "*.lproj" ! -name "en.lproj" ! -name "zh_CN.lproj" -exec rm -rf {} +
    find "$FR/Resources" -maxdepth 1 -name "*.lproj" ! -name "en.lproj" ! -name "zh_CN.lproj" -exec rm -rf {} +
    find "$FR/Resources" -maxdepth 2 -path "*/[a-z][a-z]_[A-Z]*" ! -path "*/en*" ! -path "*/zh*" -exec rm -rf {} + 2>/dev/null || true
    # 移除无用资源
    rm -rf "$C/Resources/electron.icns" "$C/Resources/default_app.asar" "$C/_CodeSignature"
    # 去除调试符号
    strip -S "$C/MacOS/Electron" 2>/dev/null || true
    strip -S "$FR/Electron Framework" 2>/dev/null || true
    strip -S "$FR/Libraries/"*.dylib 2>/dev/null || true
    strip -S "$C/Frameworks/"*.app/Contents/MacOS/* 2>/dev/null || true
    rm -rf "$EL_DIR/unpacked"
    du -sh "$TEMPLATE"
fi

# ---- 3. 为每个服务克隆出独立 App ----
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

for entry in "${SERVICES[@]}"; do
    IFS='|' read -r name url domain slug _ _ _ <<< "$entry"
    app_dir="$OUT_DIR/$name.app"
    bundle_id="com.bettergoogle.chromium.$slug"

    cp -c -R "$TEMPLATE" "$app_dir"
    C="$app_dir/Contents"

    cat > "$C/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleDisplayName</key>
    <string>$name</string>
    <key>CFBundleExecutable</key>
    <string>Electron</string>
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
    <string>11.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

    if [ -f "$ICON_DIR/$name.icns" ]; then
        cp "$ICON_DIR/$name.icns" "$C/Resources/AppIcon.icns"
    fi

    src_dir="$OUT_DIR/.src_$slug"
    mkdir -p "$src_dir"
    sed -e "s|{{APP_NAME}}|$name|g" -e "s|{{APP_URL}}|$url|g" -e "s|{{BUNDLE_ID}}|$bundle_id|g" \
        "$APP_TEMPLATE_DIR/main.js" > "$src_dir/main.js"
    sed -e "s|{{BUNDLE_ID}}|$bundle_id|g" "$APP_TEMPLATE_DIR/package.json" > "$src_dir/package.json"
    node "$ASAR_PACK" "$src_dir" "$C/Resources/default_app.asar"
    rm -rf "$src_dir"

    if ! plutil -lint "$C/Info.plist" >/dev/null; then
        echo "Info.plist 无效: $name"
        exit 1
    fi
    echo "生成: $name.app"
done

echo ""
echo "Chromium 版应用已生成 → $OUT_DIR"
