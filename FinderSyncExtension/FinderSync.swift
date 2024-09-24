import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    // This function is called when the context menu item is clicked
    @IBAction func copyCommandAndRunShortcut(_ sender: AnyObject?) {
        // Get the directory that was right-clicked on
        guard let targetURL = FIFinderSyncController.default().targetedURL() else {
            print("No targeted URL")
            return
        }

        // Set the path for the new file (NewEmptyFile.txt)
        let newFileURL = targetURL.appendingPathComponent("Untitled")
        
        // Prepare the command to copy
        let touchCommand = "/usr/bin/touch \(newFileURL.path)"
        
        // Copy the command to the clipboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(touchCommand, forType: .string)
        print("Command copied to clipboard: \(touchCommand)")
        
        // Open the Shortcuts URL to run the shortcut named "CMDRUN"
        if let url = URL(string: "shortcuts://run-shortcut?name=CMDRUN") {
            NSWorkspace.shared.open(url)
        }
    }

    // Adds a menu item to Finder's context menu
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "")
        menu.addItem(withTitle: "New File", action: #selector(copyCommandAndRunShortcut(_:)), keyEquivalent: "")
        return menu
    }
}
