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
    @State private var ruleSelection = Set<Rule>()
    @ObservedObject private var rulesManager = RulesManager()
    
    private func onAddRuleButtonPress() -> Void
    {
        let newRule = rulesManager.addRule("Empty rule", false)
        rulesManager.changeSelection(newRule.id)
    }
    
    var body: some View {
        NavigationSplitView {
            switch rulesManager.filterSelection {
            case .all:
                SidebarView(rules: $rulesManager.rules, rulesSelection: $ruleSelection, rulesManager: _rulesManager)
            case .enabled:
                SidebarView(rules: $rulesManager.rules.filter({ $0.enabled }), rulesSelection: $ruleSelection, rulesManager: _rulesManager)
            case .disabled:
                SidebarView(rules: $rulesManager.rules.filter({ !$0.enabled }), rulesSelection: $ruleSelection, rulesManager: _rulesManager)
            }
            
        } detail: {
            RuleView(rulesManager: _rulesManager, isInUse: $rulesManager.filterEnabled)
        }
        .onChange(of: rulesManager.filterSelection, {
            if (ruleSelection.count > 1)
            {
                ruleSelection.removeFirst()
            }
        })
    }
}

#Preview {
    ContentView()
}
