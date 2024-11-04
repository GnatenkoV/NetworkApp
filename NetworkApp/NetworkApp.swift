//
//  NetworkExtensionApp.swift
//  NetworkExtension
//
//  Created by user on 01.11.2024.
//

import SwiftUI

@main
struct NetworkExtensionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandMenu("Rule")
            {
                Button("Add New Rule")
                {
                    
                }
                .cornerRadius(5)
                .keyboardShortcut(KeyEquivalent("n"))
            }
        }
    }
}
