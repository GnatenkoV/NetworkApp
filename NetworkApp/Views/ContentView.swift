//
//  ContentView.swift
//  NetworkExtension
//
//  Created by user on 01.11.2024.
//

import SwiftUI
import NetworkAppLibrary

struct ContentView: View {
    @State private var filterSelection: RuleSelection = RuleSelection.all
    @ObservedObject public var rulesManager: RulesManager
    
    private func onAddRuleButtonPress() -> Void
    {
        let newRule = rulesManager.addRule("Empty rule", false)
        rulesManager.changeSelection(rule: newRule)
    }
    
    var body: some View {
        NavigationSplitView {
            switch rulesManager.filterSelection {
            case .all:
                SidebarView(rules: $rulesManager.rules, rulesManager: _rulesManager)
            case .enabled:
                SidebarView(rules: $rulesManager.rules.filter({ $0.enabled }),  rulesManager: _rulesManager)
            case .disabled:
                SidebarView(rules: $rulesManager.rules.filter({ !$0.enabled }), rulesManager: _rulesManager)
            }
            
        } detail: {
            
            if let rule = rulesManager.selectedRule
            {
                // transform optional to non-optional
                let binding = Binding { rule } set: { rulesManager.tryUpdateRule(rule: $0)}
                RuleView(rulesManager: _rulesManager, selectedRule: binding, isInUse: $rulesManager.filterEnabled)
            }
            else
            {
                Text("Select rule")
            }
        }
    }
}

#Preview {
    ContentView(rulesManager: RulesManager())
}
