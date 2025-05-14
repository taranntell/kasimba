import SwiftUI
import AppKit

// App configuration - this sets up the SwiftUI app without @main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 350),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Kasimba"
        window.center()
        
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        
        // Set up standard keyboard shortcuts
        setupMenus()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    private func setupMenus() {
        // Define main menu if it doesn't exist
        let mainMenu = NSApp.mainMenu ?? NSMenu(title: "MainMenu")
        if NSApp.mainMenu == nil {
            NSApp.mainMenu = mainMenu
        }
        
        // Add App menu
        setupAppMenu(mainMenu)
        
        // Add Edit menu
        setupEditMenu(mainMenu)
        
        // Add Window menu
        setupWindowMenu(mainMenu)
    }
    
    private func setupAppMenu(_ mainMenu: NSMenu) {
        let appName = "Kasimba"
        let appMenu = NSMenu(title: "")
        let appMenuItem = NSMenuItem(title: appName, action: nil, keyEquivalent: "")
        appMenuItem.submenu = appMenu
        
        // Add About menu item
        let aboutMenuItem = NSMenuItem(title: "About \(appName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        
        // Add Preferences menu item
        let preferencesMenuItem = NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ",")
        
        // Add Services menu item
        let servicesMenu = NSMenu(title: "Services")
        let servicesMenuItem = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
        servicesMenuItem.submenu = servicesMenu
        NSApp.servicesMenu = servicesMenu
        
        // Add Hide/Show menu items
        let hideMenuItem = NSMenuItem(title: "Hide \(appName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        let hideOthersMenuItem = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthersMenuItem.keyEquivalentModifierMask = [.option, .command]
        let showAllMenuItem = NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        
        // Add Quit menu item
        let quitMenuItem = NSMenuItem(title: "Quit \(appName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        // Add all items to app menu
        appMenu.addItem(aboutMenuItem)
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(preferencesMenuItem)
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(servicesMenuItem)
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(hideMenuItem)
        appMenu.addItem(hideOthersMenuItem)
        appMenu.addItem(showAllMenuItem)
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(quitMenuItem)
        
        // Add App menu to main menu if it doesn't exist
        if mainMenu.item(withTitle: appName) == nil {
            mainMenu.insertItem(appMenuItem, at: 0)
        }
    }
    
    private func setupEditMenu(_ mainMenu: NSMenu) {
        // Add standard Edit menu
        let editMenu = NSMenu(title: "Edit")
        let editMenuItem = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
        editMenuItem.submenu = editMenu
        
        // Add standard menu items
        let undoMenuItem = NSMenuItem(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z")
        let redoMenuItem = NSMenuItem(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z")
        let cutMenuItem = NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        let copyMenuItem = NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        let pasteMenuItem = NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        let selectAllMenuItem = NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        
        editMenu.addItem(undoMenuItem)
        editMenu.addItem(redoMenuItem)
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(cutMenuItem)
        editMenu.addItem(copyMenuItem)
        editMenu.addItem(pasteMenuItem)
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(selectAllMenuItem)
        
        // Add Edit menu to main menu
        if mainMenu.item(withTitle: "Edit") == nil {
            mainMenu.addItem(editMenuItem)
        }
    }
    
    private func setupWindowMenu(_ mainMenu: NSMenu) {
        // Add Window menu
        let windowMenu = NSMenu(title: "Window")
        let windowMenuItem = NSMenuItem(title: "Window", action: nil, keyEquivalent: "")
        windowMenuItem.submenu = windowMenu
        
        let minimizeMenuItem = NSMenuItem(title: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m")
        let zoomMenuItem = NSMenuItem(title: "Zoom", action: #selector(NSWindow.zoom(_:)), keyEquivalent: "")
        let bringAllToFrontMenuItem = NSMenuItem(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "")
        
        windowMenu.addItem(minimizeMenuItem)
        windowMenu.addItem(zoomMenuItem)
        windowMenu.addItem(NSMenuItem.separator())
        windowMenu.addItem(bringAllToFrontMenuItem)
        
        // Add Window menu to main menu
        if mainMenu.item(withTitle: "Window") == nil {
            mainMenu.addItem(windowMenuItem)
        }
        
        // Set app's window menu
        NSApp.windowsMenu = windowMenu
    }
    
    @objc private func showPreferences() {
        // This would typically show a preferences window
        // For now, just print to the console
        NSLog("Show preferences")
    }
}

// Old app structure - kept for reference but no longer used
struct KasimbaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var windowsPath: String = ""
    @State private var smbPath: String = "smb://server/share/folder/file.txt"
    @State private var serverName: String = "server_name"
    @State private var showCopiedAlert: Bool = false
    @State private var showSettings: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // transforms Windows-style file paths (like \\server\share or C:\folder) into SMB links you can copy or open in Finder
            VStack(spacing: 4){
                Text("Convert Windows Paths to SMB URLs")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.bold)
                
                Text("Transforms Windows-style file paths (like \\\\server\\share or C:\\folder) into SMB links you can copy or open in Finder.")
                //Text("Transforms Windows-style file paths into SMB (Server Message Block) URLs. It supports. Perfect for network access and file sharing, it supports both UNC (\\\\server\\share) and local drive (C:\\folder) paths, with customizable defaults and quick copy//open options.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                //Text("Windows Path to SMB Converter")
                //    .font(.title)
                //    .fontWeight(.bold)
            }
            VStack(alignment: .leading) {
                Text("Windows Path:")
                    .font(.title3)
                    .fontWeight(.medium)
                
                // Adding a ZStack to overlay the settings button on the TextField
                ZStack(alignment: .trailing) {
                    FocusableTextField(
                        placeholder: "e.g. \\\\server\\share\\folder\\file.txt",
                        text: $windowsPath,
                        onEditingChanged: { _ in convertPath() },
                        onCommit: { convertPath() }
                    )
                    .frame(minWidth: 400)
                    
                    // Settings button positioned at the trailing edge
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .padding(.trailing, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $showSettings) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Settings")
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            Text("Default Server Name:")
                                .font(.subheadline)
                            
                            // Updated TextField with custom wrapper for server name
                            FocusableTextField(
                                placeholder: "For drive paths like C:\\",
                                text: $serverName,
                                onEditingChanged: { _ in
                                    if !windowsPath.isEmpty {
                                        convertPath()
                                    }
                                },
                                onCommit: {}
                            )
                            .frame(width: 200)
                            
                            Text("Used when converting Windows drive paths (C:\\)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(width: 250)
                    }
                }
                
                Text("SMB Path:")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.top, 20)
                
                Text(smbPath)
                    .textSelection(.enabled)
                    .padding(10)
                    .frame(minWidth: 400, alignment: .leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(windowsPath.isEmpty ? Color.gray.opacity(0.6) : Color.primary)
                    .background(Color(NSColor.windowBackgroundColor).opacity(0.6))
                    .cornerRadius(5)
                    
                
                HStack {
                    Button("Copy to Clipboard") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(smbPath, forType: .string)
                        showCopiedAlert = true
                        
                        // Auto-dismiss the alert after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopiedAlert = false
                        }
                    }
                    .disabled(windowsPath.isEmpty || smbPath.starts(with: "Invalid"))
                    .keyboardShortcut(KeyEquivalent("c"), modifiers: [.command, .shift])
                    
                    Button("Open in Finder") {
                        openInFinder()
                    }
                    .disabled(windowsPath.isEmpty || smbPath.starts(with: "Invalid"))
                    .keyboardShortcut(KeyEquivalent("o"), modifiers: [.command])
                    
                    if showCopiedAlert {
                        Text("Copied!")
                            .foregroundColor(.green)
                            .transition(.opacity)
                    }
                }
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 5)
                }
            }
            
            
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Examples:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .opacity(0.5)
                    
                    Text("\\\\server\\share\\folder → smb://server/share/folder")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(0.5)
                    
                    Text("C:\\Users\\Documents → smb://\(serverName)/c$/Users/Documents")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(0.5)
                }
            }
        }
        .padding(20)
        .frame(width: 500, height: 350)
    }
    
    func convertPath() {
        // Reset error state
        showError = false
        errorMessage = ""
        
        if windowsPath.isEmpty {
            // Show placeholder SMB path when no input
            smbPath = "smb://server/share/path"
            return
        }
        
        // Handle basic conversion from Windows path to SMB
        var path = windowsPath
        
        // Clean up the input path by removing extra spaces
        path = path.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the path starts with backslashes like \\server\share
        if path.hasPrefix("\\\\") {
            // Remove the leading backslashes
            path = String(path.dropFirst(2))
            
            // Replace additional backslashes with forward slashes
            path = path.replacingOccurrences(of: "\\", with: "/")
            
            // Form the SMB URL
            smbPath = "smb://" + path
        } else if path.contains(":") {
            // Handling paths like C:\folder\file.txt
            // Split by the colon
            let components = path.split(separator: ":", maxSplits: 1)
            if components.count == 2 {
                let drive = components[0].lowercased()
                var remainingPath = components[1]
                
                // Remove leading backslash if present
                if remainingPath.hasPrefix("\\") {
                    remainingPath = remainingPath.dropFirst()
                }
                
                // Convert backslashes to forward slashes
                let formattedPath = String(remainingPath).replacingOccurrences(of: "\\", with: "/")
                
                // Use the server name from settings
                smbPath = "smb://\(serverName)/" + drive + "$/" + formattedPath
            } else {
                smbPath = "Invalid Windows path format"
            }
        } else {
            smbPath = "Invalid Windows path format"
        }
    }
    
    func openInFinder() {
        guard !smbPath.isEmpty && !smbPath.starts(with: "Invalid") else { return }
        
        guard let url = URL(string: smbPath) else {
            showError = true
            errorMessage = "Invalid URL format"
            return
        }
        
        NSWorkspace.shared.open(url, configuration: NSWorkspace.OpenConfiguration()) { app, error in
            if let error = error {
                DispatchQueue.main.async {
                    showError = true
                    errorMessage = "Error opening path: \(error.localizedDescription)"
                }
            }
        }
    }
}

// Custom TextField wrapper that supports keyboard shortcuts
struct FocusableTextField: NSViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void
    var onCommit: () -> Void
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = placeholder
        textField.delegate = context.coordinator
        textField.stringValue = text
        textField.bezelStyle = .roundedBezel
        textField.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: FocusableTextField
        
        init(_ parent: FocusableTextField) {
            self.parent = parent
        }
        
        func controlTextDidChange(_ notification: Notification) {
            guard let textField = notification.object as? NSTextField else { return }
            parent.text = textField.stringValue
            parent.onEditingChanged(true)
        }
        
        func controlTextDidEndEditing(_ notification: Notification) {
            parent.onEditingChanged(false)
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                parent.onCommit()
                return true
            }
            return false
        }
    }
}

// Preview for SwiftUI Canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 
