const { app, BrowserWindow, Menu, shell, session, Notification } = require('electron');
const fs = require('fs');
const path = require('path');

const SERVICE_NAME = '{{APP_NAME}}';
const SERVICE_URL = '{{APP_URL}}';

let win = null;

const navHistory = (wc) => wc.navigationHistory || {
  canGoBack: () => wc.canGoBack(),
  goBack: () => wc.goBack(),
  canGoForward: () => wc.canGoForward(),
  goForward: () => wc.goForward(),
};

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

  win.on('resize', saveBounds);
  win.on('move', saveBounds);
  win.on('close', saveBounds);

  win.loadURL(url || SERVICE_URL);
}

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
  app.whenReady().then(() => {
    app.setName(SERVICE_NAME);
    setupPermissions();
    setupDownloads();
    buildMenu();
    const deepUrl = process.argv.find((a) => /^bettergoogle-/i.test(a));
    createWindow(deepUrl ? deepUrl.replace(/^bettergoogle-[a-z0-9]+:\/\//i, 'https://') : null);
    app.on('activate', () => {
      if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
  });
  app.on('window-all-closed', () => app.quit());
}
