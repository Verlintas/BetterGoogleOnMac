import Cocoa
import WebKit

let appName = "{{APP_NAME}}"
let homeURLString = "{{APP_URL}}"

final class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate, WKUIDelegate, NSToolbarDelegate {

    private var window: NSWindow!
    private var webView: WKWebView!
    private var titleObservation: NSKeyValueObservation?
    private var backItem: NSToolbarItem!
    private var forwardItem: NSToolbarItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildMenu()
        buildWindow()
        buildToolbar()
        webView.load(URLRequest(url: URL(string: homeURLString)!))
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    // MARK: - Menu

    private func buildMenu() {
        let mainMenu = NSMenu()

        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "About \(appName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: "Hide \(appName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: "Quit \(appName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu

        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: "Edit")
        editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        editMenu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
        editMenu.addItem(.separator())
        editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        editMenuItem.submenu = editMenu

        let navMenuItem = NSMenuItem()
        mainMenu.addItem(navMenuItem)
        let navMenu = NSMenu(title: "Navigate")
        navMenu.addItem(withTitle: "Back", action: #selector(goBack), keyEquivalent: "[")
        navMenu.addItem(withTitle: "Forward", action: #selector(goForward), keyEquivalent: "]")
        navMenu.addItem(withTitle: "Reload", action: #selector(reloadPage), keyEquivalent: "r")
        navMenu.addItem(withTitle: "Home", action: #selector(goHome), keyEquivalent: "H")
        navMenuItem.submenu = navMenu

        let windowMenuItem = NSMenuItem()
        mainMenu.addItem(windowMenuItem)
        let windowMenu = NSMenu(title: "Window")
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
        windowMenu.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
        windowMenuItem.submenu = windowMenu
        NSApp.windowsMenu = windowMenu

        NSApp.mainMenu = mainMenu
    }

    // MARK: - Window

    private func buildWindow() {
        let rect = NSRect(x: 0, y: 0, width: 1280, height: 820)
        window = NSWindow(contentRect: rect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        window.title = appName
        window.minSize = NSSize(width: 480, height: 320)
        window.center()

        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        webView = WKWebView(frame: rect, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        // WKWebView 默认 UA 缺少 Version/Safari 标记，会被 Google 判定为不受支持的浏览器；
        // 这里伪装成现代 Safari，让 Gmail 等 Google 服务正常识别。
        // The default WKWebView UA lacks Version/Safari tokens, which Google rejects as unsupported;
        // mimic a modern Safari so Google services (Gmail, etc.) recognize it.
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15"
        webView.autoresizingMask = [.width, .height]
        webView.allowsMagnification = true
        window.contentView = webView

        titleObservation = webView.observe(\.title, options: [.new]) { [weak self] _, change in
            let pageTitle = change.newValue ?? nil
            let title: String
            if let pageTitle = pageTitle, !pageTitle.isEmpty {
                title = pageTitle
            } else {
                title = appName
            }
            self?.window.title = title
        }

        window.makeKeyAndOrderFront(nil)
    }

    private func buildToolbar() {
        let toolbar = NSToolbar(identifier: "MainToolbar")
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        toolbar.allowsUserCustomization = false
        window.toolbar = toolbar
        toolbar.validateVisibleItems()
    }

    // MARK: - NSToolbarDelegate

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier.rawValue {
        case "Back":
            backItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            backItem.image = NSImage(systemSymbolName: "chevron.left", accessibilityDescription: "Back")
            backItem.label = "Back"
            backItem.action = #selector(goBack)
            backItem.target = self
            return backItem
        case "Forward":
            forwardItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            forwardItem.image = NSImage(systemSymbolName: "chevron.right", accessibilityDescription: "Forward")
            forwardItem.label = "Forward"
            forwardItem.action = #selector(goForward)
            forwardItem.target = self
            return forwardItem
        case "Reload":
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: "Reload")
            item.label = "Reload"
            item.action = #selector(reloadPage)
            item.target = self
            return item
        case "Home":
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = NSImage(systemSymbolName: "house", accessibilityDescription: "Home")
            item.label = "Home"
            item.action = #selector(goHome)
            item.target = self
            return item
        default:
            return nil
        }
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [NSToolbarItem.Identifier("Back"), NSToolbarItem.Identifier("Forward"), .flexibleSpace, NSToolbarItem.Identifier("Reload"), NSToolbarItem.Identifier("Home")]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarDefaultItemIdentifiers(toolbar)
    }

    // MARK: - Toolbar validation

    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        switch item.itemIdentifier.rawValue {
        case "Back": return webView.canGoBack
        case "Forward": return webView.canGoForward
        default: return true
        }
    }

    private func validateToolbar() {
        backItem?.isEnabled = webView.canGoBack
        forwardItem?.isEnabled = webView.canGoForward
    }

    // MARK: - Navigation

    @objc private func goBack() { webView.goBack() }
    @objc private func goForward() { webView.goForward() }
    @objc private func reloadPage() { webView.reload() }
    @objc private func goHome() { webView.load(URLRequest(url: URL(string: homeURLString)!)) }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        validateToolbar()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        validateToolbar()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        validateToolbar()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            let scheme = url.scheme?.lowercased() ?? ""
            if scheme != "http" && scheme != "https" {
                if scheme == "mailto" || scheme == "tel" {
                    NSWorkspace.shared.open(url)
                }
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

    // MARK: - WKUIDelegate

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
        }
        return nil
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: window) { _ in completionHandler() }
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: window) { response in
            completionHandler(response == .alertFirstButtonReturn)
        }
    }
}

let application = NSApplication.shared
let appDelegate = AppDelegate()
application.delegate = appDelegate
application.setActivationPolicy(.regular)
application.run()
