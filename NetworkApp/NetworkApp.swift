//
//  NetworkExtensionApp.swift
//  NetworkExtension
//
//  Created by user on 01.11.2024.
//

import SwiftUI

@main
struct NetworkExtensionApp: App {
    @ObservedObject var rulesManager = RulesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(rulesManager: rulesManager)
        }
        .commands {
            CommandMenu("Rule")
            {
                Button("Add New Rule")
                {
                    let rule = self.rulesManager.addRule("", false)
                    self.rulesManager.changeSelection(rule: rule)
                }
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("n"))
                
                Button("Save Rules")
                {
                    self.rulesManager.saveRules()
                }
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("s"))
                
                Button("Restore Rules")
                {
                    self.rulesManager.loadRules()
                }
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("z"))
            }
            
            CommandMenu("Extension")
            {
                Button("Install", action: {
                    
                })
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("i"))
                
                Button("Uninstall", action: {
                    
                })
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("u"))
                
                Button("Start", action: {
                    
                })
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("r"))
                
                Button("Stop", action: {
                    
                })
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("q"))
            }
        }
    }
}
