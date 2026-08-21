# BetterGoogleOnMac

> 在 macOS 上像原生应用一样直接使用 Google 服务，无需在浏览器里输入网址。
> Use Google services directly on macOS like native apps, without typing URLs in a browser.

macOS 没有官方的 Google 桌面客户端（如 Gmail、Drive）。
macOS has no official Google desktop clients (e.g. Gmail, Drive).
本项目为每个 Google 服务生成独立的 macOS 应用，点击即用。
This project generates a standalone macOS app for each Google service — one click, and you're in.

---

## ⬇️ 下载 / Download

### 一键全部安装 / All-in-one (recommended)

| 版本 / Version | 说明 / Description | 下载 / Download |
|---|---|---|
| **Chrome 版合集 / Chrome Apps** | 全部 10 个应用，Chrome 独立窗口（无地址栏），复用 Chrome 登录态；需已安装 Google Chrome / All 10 apps as Chrome standalone windows (no address bar), reuses your Chrome login; requires Google Chrome | [BetterGoogleOnMac-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/BetterGoogleOnMac-Chrome-v1.1.0.zip) |
| **原生版合集 / Native Apps** | 全部 10 个应用，真正的原生应用（Swift + WKWebView，Safari 内核），不依赖 Chrome；通用二进制，Apple Silicon 与 Intel 均支持 / All 10 apps as true native apps (Swift + WKWebView, Safari engine), no Chrome needed; universal binary for Apple Silicon and Intel | [BetterGoogleOnMac-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/BetterGoogleOnMac-Native-v1.1.0.zip) |

### 单个服务下载 / Individual apps

每个服务单独打包，各一个 zip / Each service is packaged separately, one zip per app:

| 服务 / App | 简介 / Description | Chrome 版 / Chrome | 原生版 / Native |
|---|---|---|---|
| Gmail | 邮件收发 / Email client | [Gmail-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Gmail-Chrome-v1.1.0.zip) | [Gmail-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Gmail-Native-v1.1.0.zip) |
| Google Calendar | 日程管理 / Calendar & scheduling | [Google-Calendar-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Calendar-Chrome-v1.1.0.zip) | [Google-Calendar-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Calendar-Native-v1.1.0.zip) |
| Google Drive | 文件云存储 / Cloud storage | [Google-Drive-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Drive-Chrome-v1.1.0.zip) | [Google-Drive-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Drive-Native-v1.1.0.zip) |
| Google Docs | 在线文档 / Word processing | [Google-Docs-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Docs-Chrome-v1.1.0.zip) | [Google-Docs-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Docs-Native-v1.1.0.zip) |
| Google Sheets | 在线表格 / Spreadsheets | [Google-Sheets-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Sheets-Chrome-v1.1.0.zip) | [Google-Sheets-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Sheets-Native-v1.1.0.zip) |
| Google Slides | 在线演示 / Presentations | [Google-Slides-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Slides-Chrome-v1.1.0.zip) | [Google-Slides-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Slides-Native-v1.1.0.zip) |
| Google Meet | 视频会议 / Video meetings | [Google-Meet-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Meet-Chrome-v1.1.0.zip) | [Google-Meet-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Meet-Native-v1.1.0.zip) |
| Google Photos | 照片管理 / Photo storage | [Google-Photos-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Photos-Chrome-v1.1.0.zip) | [Google-Photos-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Photos-Native-v1.1.0.zip) |
| YouTube | 视频平台 / Video sharing | [YouTube-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/YouTube-Chrome-v1.1.0.zip) | [YouTube-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/YouTube-Native-v1.1.0.zip) |
| Google Maps | 地图导航 / Maps & navigation | [Google-Maps-Chrome-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Maps-Chrome-v1.1.0.zip) | [Google-Maps-Native-v1.1.0.zip](https://github.com/Verlintas/BetterGoogleOnMac/releases/latest/download/Google-Maps-Native-v1.1.0.zip) |

其他版本 / Other versions: [Releases 页面 / Releases page](https://github.com/Verlintas/BetterGoogleOnMac/releases)

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
git clone https://github.com/Verlintas/BetterGoogleOnMac.git
cd BetterGoogleOnMac
bash scripts/create_all.sh            # 一键构建并安装到 ~/Applications/BetterGoogleOnMac
# 构建产物也会出现在 build/ 目录 / Build artifacts also land in build/
bash scripts/package_release.sh       # 生成 Release 用 zip / Produce release zips
```

要求 / Requirements:
- macOS 12+（原生版）/ macOS 12+ (native version)
- Xcode 命令行工具（原生版编译用）/ Xcode Command Line Tools (only to compile native apps)
- Google Chrome（Chrome 版运行用）/ Google Chrome (only to run Chrome apps)

## 常见问题 / FAQ

**Q: 需要登录 Google 吗？**
需要。首次打开任意应用后按页面提示登录一次，之后所有服务共享该登录状态。
Yes. Log in once when first prompted; all services share the same login afterwards.

**Q: 原生版和 Chrome 版有什么区别？**
原生版不依赖 Chrome，是独立的原生应用（Safari 内核），性能与体验更像正式 App；Chrome 版共享你 Chrome 里的登录和书签，且适用于未提供原生二进制的旧系统。
Native apps are standalone (Safari engine) and don't depend on Chrome; Chrome apps share your Chrome login/bookmarks and work on systems where no native binary is provided.

**Q: 可以修改某个应用的网址吗？**
可以，修改 `services.sh` 后重新运行 `scripts/create_all.sh` 即可。
Yes — edit `services.sh` and re-run `scripts/create_all.sh`.

**Q: 如何卸载？**
把对应的 `.app` 拖入废纸篓即可，无残留文件。
Just drag the `.app` files to Trash; nothing else is installed.

## 技术实现 / How it works

- Chrome 版：`Google Chrome --app=<URL>` 独立窗口模式。
  Chrome version: `Google Chrome --app=<URL>` standalone window mode.
- 原生版：AppKit + WKWebView，`swiftc` 编译，`lipo` 合成 arm64 + x86_64 通用二进制。
  Native version: AppKit + WKWebView, compiled with `swiftc`, `lipo`-merged into a universal arm64 + x86_64 binary.
- 图标：优先下载 Google 官方 favicon，失败时自动生成本地品牌色图标。
  Icons: Google's official favicon is preferred; a local branded icon is generated automatically when unavailable.

## 许可证 / License

[MIT](LICENSE)
