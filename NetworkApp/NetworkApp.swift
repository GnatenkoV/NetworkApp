import SwiftUI
import NetworkExtension

@main
struct NetworkExtensionApp: App {
    @ObservedObject var rulesManager = RulesManager()
    @ObservedObject var installationManager = InstallationManager()
    @ObservedObject var filterManager = FilterManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(rulesManager: rulesManager, installationManager: installationManager, filterManager: filterManager)
        }
        .commands {
            CommandMenu("Rule")
            {
                Button("Add New Rule") {
                    let rule = self.rulesManager.addRule("", false)
                    self.rulesManager.changeSelection(rule: rule)
                }
                .keyboardShortcut(KeyEquivalent("n"))
                
                Button("Remove Selected Rule") {
                    if (self.rulesManager.selectedRule != nil) {
                        self.rulesManager.removeRule(self.rulesManager.selectedRule!)
                        self.rulesManager.selectedRule = nil
                    }
                }.keyboardShortcut(KeyEquivalent("r"))
                
                Button("Save Rules") {
                    self.rulesManager.saveRules()
                    self.filterManager.restart()
                    self.filterManager.updateStatus()
                }
                .keyboardShortcut(KeyEquivalent("s"))
                
                Button("Restore Rules") {
                    self.rulesManager.loadRules()
                }
                .keyboardShortcut(KeyEquivalent("z"))
            }
            
            CommandMenu("Extension")
            {
                Button("Install", action: {
                    self.installationManager.install()
                })
                .keyboardShortcut(KeyEquivalent("i"), modifiers: [.command])
                
                Button("Uninstall", action: {
                    self.installationManager.uninstall()
                })
                .keyboardShortcut(KeyEquivalent("u"), modifiers: [.command])
                
                Button("Start", action: {
                    self.filterManager.start()
                })
                .keyboardShortcut(KeyEquivalent("i"), modifiers: [.command, .shift])
                
                Button("Stop", action: {
                    self.filterManager.stop()
                })
                .keyboardShortcut(KeyEquivalent("u"), modifiers: [.command, .shift])
            }
        }
    }
}
