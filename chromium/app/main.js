const { app, BrowserWindow, Menu, shell } = require('electron');

const SERVICE_NAME = '{{APP_NAME}}';
const SERVICE_URL = '{{APP_URL}}';

let win = null;

const navHistory = (wc) => wc.navigationHistory || {
  canGoBack: () => wc.canGoBack(),
  goBack: () => wc.goBack(),
  canGoForward: () => wc.canGoForward(),
  goForward: () => wc.goForward(),
};

function createWindow() {
  win = new BrowserWindow({
    width: 1280,
    height: 820,
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

  wc.on('will-navigate', (event, url) => {
    if (!/^https?:/i.test(url)) {
      event.preventDefault();
      shell.openExternal(url);
    }
  });

  win.on('page-title-updated', (event, title) => {
    event.preventDefault();
    win.setTitle(title && title.trim() ? title : SERVICE_NAME);
  });

  win.loadURL(SERVICE_URL);
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
  app.on('second-instance', () => {
    if (win) {
      if (win.isMinimized()) win.restore();
      win.focus();
    }
  });
  app.whenReady().then(() => {
    app.setName(SERVICE_NAME);
    buildMenu();
    createWindow();
    app.on('activate', () => {
      if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
  });
  app.on('window-all-closed', () => app.quit());
}
