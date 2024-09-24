import SwiftUI
import Cocoa

struct ContentView: View {
    @State private var isFinderExtensionEnabled = true // Track the state of the extension
    
    var body: some View {
        VStack {
            Image(systemName: isFinderExtensionEnabled ? "checkmark" : "xmark")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(isFinderExtensionEnabled ? "Finder Extension is Enabled" : "Finder Extension is Disabled")
            Button(action: toggleFinderExtension) {
                Text(isFinderExtensionEnabled ? "Disable Finder Extension" : "Enable Finder Extension")
            }
        }
        .padding()
    }

    // Function to toggle the Finder extension on/off
    func toggleFinderExtension() {
        isFinderExtensionEnabled.toggle()
        let bundleIdentifier = "com.example.EmptyFileCreator.FinderSyncExtension" // Replace this with your extension's bundle ID
        
        if isFinderExtensionEnabled {
            enableFinderExtension(bundleIdentifier: bundleIdentifier)
        } else {
            disableFinderExtension(bundleIdentifier: bundleIdentifier)
        }
    }

    func enableFinderExtension(bundleIdentifier: String) {
        // Enable the Finder Sync extension
        let enableProcess = Process()
        enableProcess.launchPath = "/usr/bin/pluginkit"
        enableProcess.arguments = ["-e", "use", "-i", bundleIdentifier]
        enableProcess.launch()
        enableProcess.waitUntilExit()
        
        // Force Finder to reload extensions
        reloadFinderExtensions()
        
        print("Finder extension \(bundleIdentifier) enabled")
    }

    func disableFinderExtension(bundleIdentifier: String) {
        // Disable the Finder Sync extension
        let disableProcess = Process()
        disableProcess.launchPath = "/usr/bin/pluginkit"
        disableProcess.arguments = ["-r", bundleIdentifier]
        disableProcess.launch()
        disableProcess.waitUntilExit()
        
        // Force Finder to reload extensions
        reloadFinderExtensions()
        
        print("Finder extension \(bundleIdentifier) disabled")
    }

    func reloadFinderExtensions() {
        // Kill FinderSync to ensure Finder reloads the extensions
        let pkillProcess = Process()
        pkillProcess.launchPath = "/usr/bin/pkill"
        pkillProcess.arguments = ["-f", "FinderSync"]
        pkillProcess.launch()
        pkillProcess.waitUntilExit()
        
        // Optional: Restart Finder as a fallback if needed
        let finderRestartProcess = Process()
        finderRestartProcess.launchPath = "/usr/bin/killall"
        finderRestartProcess.arguments = ["Finder"]
        finderRestartProcess.launch()
        finderRestartProcess.waitUntilExit()
        
        print("Reloaded Finder extensions")
    }
}

#Preview {
    ContentView()
}
