#!/bin/bash
# 生成 Chrome 独立窗口版 .app（无地址栏、无标签页，复用 Chrome 登录态）
# Generate Chrome standalone-window .app bundles (no address bar, no tabs, reuse Chrome login)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
source "$ROOT_DIR/services.sh"

OUT_DIR="${1:-$ROOT_DIR/build/chrome_apps}"
ICON_DIR="$ROOT_DIR/build/icons"
CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

for entry in "${SERVICES[@]}"; do
    IFS='|' read -r name url domain slug _ _ <<< "$entry"
    app_name="$name (Chrome)"
    app_dir="$OUT_DIR/$app_name.app"
    bundle_id="com.bettergoogle.chrome.$slug"
    mkdir -p "$app_dir/Contents/MacOS" "$app_dir/Contents/Resources"

    cat > "$app_dir/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleDisplayName</key>
    <string>$app_name</string>
    <key>CFBundleExecutable</key>
    <string>launcher</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>$bundle_id</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$app_name</string>
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

    cat > "$app_dir/Contents/MacOS/launcher" <<EOF
#!/bin/bash
# 用 Chrome 的 --app 模式打开独立窗口
# Open a standalone window using Chrome's --app mode
CHROME="$CHROME_BIN"
if [ ! -x "\$CHROME" ]; then
    osascript -e 'display alert "Google Chrome 未安装 / Chrome not installed" message "请先安装 Google Chrome：https://www.google.com/chrome/ \\nPlease install Google Chrome first: https://www.google.com/chrome/"' >/dev/null 2>&1
    exit 1
fi
exec "\$CHROME" --app="$url" "\$@"
EOF
    chmod +x "$app_dir/Contents/MacOS/launcher"

    if [ -f "$ICON_DIR/$name.icns" ]; then
        cp "$ICON_DIR/$name.icns" "$app_dir/Contents/Resources/AppIcon.icns"
    fi
    printf 'APPL????' > "$app_dir/Contents/PkgInfo"

    if ! plutil -lint "$app_dir/Contents/Info.plist" >/dev/null; then
        echo "Info.plist 无效: $app_name"
        exit 1
    fi
    echo "生成: $app_name"
done

echo ""
echo "Chrome 版应用已生成 → $OUT_DIR"
