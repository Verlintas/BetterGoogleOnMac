const { app, BrowserWindow, Menu, shell, session, Notification } = require('electron');
const fs = require('fs');
const path = require('path');

const SERVICE_NAME = '{{APP_NAME}}';
const SERVICE_URL = '{{APP_URL}}';
const REPO = 'Verlintas/GoogleOnYourMac';

let win = null;

// ---------- 日志 / Logging ----------
function logFile() {
  return path.join(app.getPath('userData'), 'log.txt');
}
function log(msg) {
  try {
    fs.appendFileSync(logFile(), `[${new Date().toISOString()}] ${msg}\n`);
  } catch {}
}
process.on('uncaughtException', (err) => log(`uncaughtException: ${err && (err.stack || err)}`));
process.on('unhandledRejection', (reason) => log(`unhandledRejection: ${reason}`));

// ---------- 版本比较 / Version compare ----------
function compareVersions(a, b) {
  const pa = String(a).replace(/^v/, '').split('.').map(Number);
  const pb = String(b).replace(/^v/, '').split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const d = (pa[i] || 0) - (pb[i] || 0);
    if (d !== 0) return d > 0 ? 1 : -1;
  }
  return 0;
}

// ---------- 更新检查 / Update check ----------
let updateChecked = false;
function checkForUpdates(manual) {
  fetch(`https://api.github.com/repos/${REPO}/releases/latest`, {
    headers: { 'User-Agent': 'GoogleOnYourMac', 'Accept': 'application/vnd.github+json' },
  })
    .then((r) => (r.ok ? r.json() : Promise.reject(new Error(`HTTP ${r.status}`))))
    .then((d) => {
      updateChecked = true;
      const latest = d.tag_name || '';
      const current = `v${app.getVersion()}`;
      if (compareVersions(latest, current) > 0) {
        log(`update available: ${current} -> ${latest}`);
        if (Notification.isSupported()) {
          new Notification({
            title: SERVICE_NAME,
            body: `发现新版本 ${latest} / New version ${latest} available`,
          }).show();
        }
      } else if (manual) {
        new Notification({ title: SERVICE_NAME, body: '已是最新版本 / You are up to date' }).show();
      }
    })
    .catch((e) => log(`update check failed: ${e}`));
}

// ---------- 错误页 / Error page ----------
function errorPageHtml(title, detail) {
  return `<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8">
<style>
  body{font-family:-apple-system,sans-serif;background:#fafafa;color:#333;display:flex;align-items:center;justify-content:center;height:100vh;margin:0}
  .box{text-align:center;max-width:480px;padding:32px}
  h1{font-size:22px;margin:0 0 8px}
  p{font-size:14px;color:#666;line-height:1.6;margin:0 0 24px;word-break:break-all}
  button{font-size:14px;padding:8px 28px;border-radius:20px;border:none;background:#1a73e8;color:#fff;cursor:pointer}
  button:hover{background:#1765cc}
</style></head><body><div class="box">
  <h1>${title}</h1><p>${detail}</p>
  <button onclick="location.href='${SERVICE_URL}'">重新加载 / Reload</button>
</div></body></html>`;
}

function showErrorPage(code, desc) {
  if (win && !win.isDestroyed()) {
    win.webContents.loadURL(
      'data:text/html;charset=utf-8,' + encodeURIComponent(errorPageHtml('加载失败 / Failed to load', `${desc} (${code})`))
    );
  }
}

// ---------- 窗口 / Window ----------
function boundsFile() {
  return path.join(app.getPath('userData'), 'window-bounds.json');
}

function loadBounds() {
  try {
    const b = JSON.parse(fs.readFileSync(boundsFile(), 'utf8'));
    const displays = require('electron').screen.getAllDisplays();
    const visible = displays.some((d) => {
      const a = d.workArea;
      return b.x < a.x + a.width && b.x + b.width > a.x && b.y < a.y + a.height && b.y + b.height > a.y;
    });
    return visible ? b : null;
  } catch {
    return null;
  }
}

function saveBounds() {
  if (!win || win.isDestroyed()) return;
  try {
    fs.writeFileSync(boundsFile(), JSON.stringify(win.getNormalBounds()));
  } catch {}
}

function createWindow(url) {
  const saved = loadBounds();
  win = new BrowserWindow({
    width: saved ? saved.width : 1280,
    height: saved ? saved.height : 820,
    x: saved ? saved.x : undefined,
    y: saved ? saved.y : undefined,
    minWidth: 480,
    minHeight: 320,
    title: SERVICE_NAME,
    backgroundColor: '#ffffff',
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
      spellcheck: false,
    },
  });

  const wc = win.webContents;

  wc.setWindowOpenHandler(({ url }) => {
    if (/^https?:/i.test(url)) {
      wc.loadURL(url);
    } else {
      shell.openExternal(url);
    }
    return { action: 'deny' };
  });

  wc.on('will-navigate', (event, target) => {
    if (!/^https?:/i.test(target)) {
      event.preventDefault();
      shell.openExternal(target);
    }
  });

  win.on('page-title-updated', (event, title) => {
    event.preventDefault();
    win.setTitle(title && title.trim() ? title : SERVICE_NAME);
  });

  // 渲染进程崩溃自动恢复 / Auto-recover from renderer crashes
  wc.on('render-process-gone', (event, details) => {
    log(`renderer gone: ${JSON.stringify(details)}`);
    if (details.reason !== 'clean-exit') {
      setTimeout(() => {
        if (win && !win.isDestroyed()) {
          log('reloading after renderer crash');
          win.loadURL(SERVICE_URL);
        }
      }, 1500);
    }
  });

  // 加载失败显示错误页 / Show error page on load failure
  wc.on('did-fail-load', (event, code, desc, failedUrl, isMainFrame) => {
    if (isMainFrame && code !== -3) {
      log(`did-fail-load: ${code} ${desc} ${failedUrl}`);
      showErrorPage(code, desc);
    }
  });

  win.on('resize', saveBounds);
  win.on('move', saveBounds);
  win.on('close', saveBounds);

  win.loadURL(url || SERVICE_URL);
}

// ---------- 权限 / Permissions ----------
function setupPermissions() {
  const s = session.defaultSession;
  const allowed = new Set(['media', 'notifications', 'clipboard-read', 'clipboard-sanitized-write', 'display-capture', 'pointerLock', 'fullscreen']);
  s.setPermissionRequestHandler((wc, permission, callback) => {
    callback(allowed.has(permission));
  });
  s.setPermissionCheckHandler((wc, permission) => {
    return allowed.has(permission);
  });
}

// ---------- 下载 / Downloads ----------
function setupDownloads() {
  session.defaultSession.on('will-download', (event, item) => {
    item.on('done', (e, state) => {
      if (state === 'completed') {
        if (Notification.isSupported()) {
          new Notification({
            title: SERVICE_NAME,
            body: `下载完成 / Download finished: ${item.getFilename()}`,
          }).show();
        }
      }
    });
  });
}

// ---------- 菜单 / Menu ----------
function buildMenu() {
  const template = [
    {
      label: SERVICE_NAME,
      submenu: [
        { role: 'about' },
        { type: 'separator' },
        { role: 'hide' },
        { role: 'hideOthers' },
        { role: 'unhide' },
        { type: 'separator' },
        { label: '检查更新 / Check for Updates', click: () => checkForUpdates(true) },
        { type: 'separator' },
        { role: 'quit' },
      ],
    },
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' }, { role: 'redo' }, { type: 'separator' },
        { role: 'cut' }, { role: 'copy' }, { role: 'paste' },
        { role: 'selectAll' },
      ],
    },
    {
      label: 'Navigate',
      submenu: [
        { label: 'Back', accelerator: 'Cmd+[', click: () => navHistory(win.webContents).goBack() },
        { label: 'Forward', accelerator: 'Cmd+]', click: () => navHistory(win.webContents).goForward() },
        { type: 'separator' },
        { label: 'Reload', accelerator: 'Cmd+R', click: () => win.webContents.reload() },
        { label: 'Home', accelerator: 'Cmd+Shift+H', click: () => win.loadURL(SERVICE_URL) },
        { type: 'separator' },
        { label: 'New Window', accelerator: 'Cmd+N', click: () => createWindow() },
      ],
    },
    {
      label: 'Window',
      submenu: [
        { role: 'minimize' },
        { role: 'close' },
      ],
    },
  ];
  Menu.setApplicationMenu(Menu.buildFromTemplate(template));
}

const navHistory = (wc) => wc.navigationHistory || {
  canGoBack: () => wc.canGoBack(),
  goBack: () => wc.goBack(),
  canGoForward: () => wc.canGoForward(),
  goForward: () => wc.goForward(),
};

const gotLock = app.requestSingleInstanceLock();
if (!gotLock) {
  app.quit();
} else {
  app.on('second-instance', (event, argv) => {
    const url = argv.find((a) => /^bettergoogle-/i.test(a));
    if (win) {
      if (win.isMinimized()) win.restore();
      win.focus();
      if (url) win.loadURL(url.replace(/^bettergoogle-[a-z0-9]+:\/\//i, 'https://'));
    }
  });
  app.on('open-url', (event, url) => {
    event.preventDefault();
    if (win) {
      if (win.isMinimized()) win.restore();
      win.focus();
      win.loadURL(url.replace(/^bettergoogle-[a-z0-9]+:\/\//i, 'https://'));
    }
  });

  // GPU 等子进程崩溃记录 / Log child-process crashes
  app.on('child-process-gone', (event, details) => {
    log(`child-process-gone: ${details.type} ${details.reason}`);
  });

  app.whenReady().then(() => {
    app.setName(SERVICE_NAME);
    log(`started ${SERVICE_NAME} v${app.getVersion()}`);
    setupPermissions();
    setupDownloads();
    buildMenu();
    const deepUrl = process.argv.find((a) => /^bettergoogle-/i.test(a));
    createWindow(deepUrl ? deepUrl.replace(/^bettergoogle-[a-z0-9]+:\/\//i, 'https://') : null);
    app.on('activate', () => {
      if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
    setTimeout(() => checkForUpdates(false), 10000);
  });
  app.on('window-all-closed', () => app.quit());
}
