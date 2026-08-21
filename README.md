# BetterGoogleOnMac

[![Release](https://img.shields.io/badge/release-auto--build-blue)](https://github.com/Verlintas/GoogleOnYourMac/releases/latest)

> 在 macOS 上像原生应用一样直接使用 Google 服务，无需在浏览器里输入网址。
> Use Google services directly on macOS like native apps, without typing URLs in a browser.

macOS 没有官方的 Google 桌面客户端（如 Gmail、Drive）。
macOS has no official Google desktop clients (e.g. Gmail, Drive).
本项目为每个 Google 服务生成独立的 macOS 应用，点击即用。
This project generates a standalone macOS app for each Google service — one click, and you're in.

---

## ⬇️ 下载 / Download

> **三个版本选一个就行：日常使用推荐 Chromium 版（最流畅）** / Pick one edition: **Chromium edition is recommended for daily use (smoothest)**
> - **Chromium 版**：内置完整 Chromium 内核（剥离后的 Electron，仅保留必需组件），不依赖任何浏览器，Google 服务识别为 Chrome，体验与 Chrome 一致（推荐）/ self-contained stripped Chromium engine, no browser needed, Google sees it as Chrome
> - **Chrome 版**：零体积，用你已安装的 Chrome 打开独立窗口，与 Chrome 共享登录 / zero-size, opens a standalone window via your installed Chrome, shares its login
> - **Safari 版**：Swift + WKWebView（Safari 内核），零体积，Google 服务页面更省资源 / Safari engine, zero-size, lighter on resources

### 一键全部安装 / All-in-one

| 版本 / Version | 说明 / Description | 下载 / Download |
|---|---|---|
| **Chromium 版合集 (arm64)** | 全部 10 个应用，各自内置 Chromium 内核（总包约 1GB）/ All 10 apps, each with its own Chromium engine (~1GB total) | [BetterGoogleOnMac-Chromium-v2.1.0.zip](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/BetterGoogleOnMac-Chromium-v2.1.0.zip) |
| **Chromium 版合集 (x64)** | 同上，Intel Mac 使用 / Same, for Intel Macs | [BetterGoogleOnMac-Chromium-x64-v2.1.0.zip](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/BetterGoogleOnMac-Chromium-x64-v2.1.0.zip) |
| **Chrome 版合集** | 全部 10 个应用，Chrome 独立窗口；需已安装 Google Chrome / requires Google Chrome | [BetterGoogleOnMac-Chrome-v2.1.0.zip](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/BetterGoogleOnMac-Chrome-v2.1.0.zip) |
| **Safari 版合集** | 全部 10 个应用，Swift + WKWebView，通用二进制 (arm64 + x86_64) / universal binary | [BetterGoogleOnMac-Safari-v2.1.0.zip](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/BetterGoogleOnMac-Safari-v2.1.0.zip) |

### 单个服务下载 / Individual apps

每个服务单独打包，Chromium 版提供 arm64（Apple Silicon）和 x64（Intel）两种 /
Each service packaged separately; Chromium edition comes in arm64 (Apple Silicon) and x64 (Intel).
Chromium 版功能：摄像头/麦克风（Meet 视频通话）、下载完成通知、窗口位置记忆、深链接 `bettergoogle-<service>://` /
Chromium features: camera/mic (Meet calls), download notifications, window memory, deep links `bettergoogle-<service>://`

| 服务 / App | 简介 / Description | Chromium 版 (推荐) | Chrome 版 | Safari 版 |
|---|---|---|---|---|
| Gmail | 邮件收发 / Email client | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Gmail-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Gmail-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Gmail-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Gmail-Safari-v2.1.0.zip) |
| Google Calendar | 日程管理 / Calendar & scheduling | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Calendar-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Calendar-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Calendar-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Calendar-Safari-v2.1.0.zip) |
| Google Drive | 文件云存储 / Cloud storage | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Drive-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Drive-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Drive-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Drive-Safari-v2.1.0.zip) |
| Google Docs | 在线文档 / Word processing | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Docs-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Docs-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Docs-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Docs-Safari-v2.1.0.zip) |
| Google Sheets | 在线表格 / Spreadsheets | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Sheets-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Sheets-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Sheets-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Sheets-Safari-v2.1.0.zip) |
| Google Slides | 在线演示 / Presentations | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Slides-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Slides-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Slides-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Slides-Safari-v2.1.0.zip) |
| Google Meet | 视频会议 / Video meetings | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Meet-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Meet-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Meet-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Meet-Safari-v2.1.0.zip) |
| Google Photos | 照片管理 / Photo storage | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Photos-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Photos-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Photos-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Photos-Safari-v2.1.0.zip) |
| YouTube | 视频平台 / Video sharing | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/YouTube-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/YouTube-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/YouTube-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/YouTube-Safari-v2.1.0.zip) |
| Google Maps | 地图导航 / Maps & navigation | [arm64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Maps-Chromium-v2.1.0.zip) · [x64](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Maps-Chromium-x64-v2.1.0.zip) | [Chrome](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Maps-Chrome-v2.1.0.zip) | [Safari](https://github.com/Verlintas/GoogleOnYourMac/releases/latest/download/Google-Maps-Safari-v2.1.0.zip) |

其他版本 / Other versions: [Releases 页面 / Releases page](https://github.com/Verlintas/GoogleOnYourMac/releases)

---

## 安装 / Installation

1. 下载对应的 zip（合集或单个服务均可）并解压。
   Download the zip you need (all-in-one or a single service) and unzip it.
2. 把 `.app` 拖入「应用程序」文件夹（推荐），或直接双击使用。
   Drag the `.app` files into your Applications folder (recommended), or just double-click to use them.
3. 首次打开若提示「无法验证开发者」，右键点击应用 →「打开」即可（未签名应用的正常提示，源码完全开源可审计）。
   If macOS shows "cannot verify developer" on first launch, right-click the app → "Open". This is normal for unsigned apps; the source is fully open for audit.

## 使用 / Usage

- 双击即可打开对应服务，无需输入网址。
  Double-click to open the service — no URL typing needed.
- Chrome 版：独立窗口，无地址栏、无标签页；登录信息与 Chrome 浏览器共享。
  Chrome version: standalone window without address bar or tabs; shares login with your Chrome browser.
- 原生版快捷键 / Native version shortcuts:
  - `Cmd + [` 后退 / Back
  - `Cmd + ]` 前进 / Forward
  - `Cmd + R` 刷新 / Reload
  - `Cmd + Shift + H` 回到首页 / Home
  - 工具栏也有后退/前进/刷新/首页按钮 / Toolbar also has Back/Forward/Reload/Home buttons

## 从源码构建 / Build from source

```bash
git clone https://github.com/Verlintas/GoogleOnYourMac.git
cd BetterGoogleOnMac
bash scripts/create_all.sh            # 一键构建并安装到 ~/Applications/BetterGoogleOnMac
# 构建产物也会出现在 build/ 目录 / Build artifacts also land in build/
bash scripts/package_release.sh       # 生成 Release 用 zip / Produce release zips

# 发版：推送 v* tag 后 GitHub Actions 自动构建并发布 Release（公开仓库免费）
# Release: push a v* tag and GitHub Actions builds and publishes automatically (free for public repos)
git tag v2.1.0 && git push origin v2.1.0
```

要求 / Requirements:
- Chromium 版：Apple Silicon (arm64) / Chromium edition: Apple Silicon (arm64)
- Safari 版：macOS 12+，Intel 与 Apple Silicon 均支持 / Safari edition: macOS 12+, Intel & Apple Silicon
- 构建 Chromium 版需要 Node.js 与网络（Electron 从 npmmirror 镜像下载）/ Building Chromium edition needs Node.js and network

## 常见问题 / FAQ

**Q: 需要登录 Google 吗？**
需要。首次打开任意应用后按页面提示登录一次，之后所有服务共享该登录状态。
Yes. Log in once when first prompted; all services share the same login afterwards.

**Q: Chromium 版、Chrome 版、Safari 版有什么区别？**
Chromium 版内置完整 Chromium 内核（Electron 剥离版，仅保留必需组件），Google 识别为 Chrome，流畅度与 Chrome 一致，但每个 App 约 103MB（Apple Silicon）；Chrome 版用你已装的 Chrome 开独立窗口，零体积但需安装 Chrome；Safari 版是 WKWebView（Safari 内核）原生应用，零体积但 Google 页面流畅度不如 Chromium。
Chromium edition embeds a stripped Chromium engine (~103MB each, Apple Silicon), Google treats it as Chrome — smoothest; Chrome edition is zero-size but requires Chrome installed; Safari edition is a WKWebView native app (zero-size) that's less smooth on Google apps.

**Q: 可以修改某个应用的网址吗？**
可以，修改 `services.sh` 后重新运行 `scripts/create_all.sh` 即可。
Yes — edit `services.sh` and re-run `scripts/create_all.sh`.

**Q: 如何卸载？**
把对应的 `.app` 拖入废纸篓即可，无残留文件。
Just drag the `.app` files to Trash; nothing else is installed.

## 技术实现 / How it works

- Chromium 版：Electron（Chromium 138）自包含应用，剥离了 50+ 语言包、调试符号等非必需组件；每个 App 独立打包，用 `default_app.asar` 加载服务入口（`main.js`），支持 Cmd+[ / ] 前进后退等快捷键。
  Chromium edition: self-contained Electron (Chromium 138) apps stripped of 50+ locale packs and debug symbols; each app loads its service entry via `default_app.asar` (`main.js`), with Cmd+[ / ] navigation shortcuts.
- Chrome 版：`Google Chrome --app=<URL>` 独立窗口模式。
  Chrome version: `Google Chrome --app=<URL>` standalone window mode.
- Safari 版：AppKit + WKWebView，`swiftc` 编译，`lipo` 合成 arm64 + x86_64 通用二进制；伪装现代 Safari UA 通过 Google 浏览器检测。
  Safari version: AppKit + WKWebView, compiled with `swiftc`, `lipo`-merged universal binary; mimics a modern Safari UA to pass Google's browser check.
- 图标：优先使用 Google 官方产品图标（gstatic CDN），其次 Google favicon，最后自动生成本地品牌色图标。
  Icons: Google's official product icons (gstatic CDN) are preferred, then Google favicon, and finally a locally generated branded icon.

## 许可证 / License

[MIT](LICENSE)
