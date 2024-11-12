import SwiftUI
import NetworkAppLibrary

struct ContentView: View {
    @State private var filterSelection: RuleSelection = RuleSelection.all
    @ObservedObject public var rulesManager: RulesManager
    @ObservedObject public var installationManager: InstallationManager
    @ObservedObject public var filterManager: FilterManager
    
    private func onAddRuleButtonPress() -> Void
    {
        let newRule = rulesManager.addRule("Empty rule", false)
        rulesManager.changeSelection(rule: newRule)
    }
    
    var body: some View {
        NavigationSplitView {
            switch rulesManager.filterSelection {
            case .all:
                SidebarView(rules: $rulesManager.rules, rulesManager: _rulesManager, installationManager: _installationManager, filterManager: _filterManager)
            case .enabled:
                SidebarView(rules: $rulesManager.rules.filter({ $0.enabled }),  rulesManager: _rulesManager, installationManager: _installationManager, filterManager: _filterManager)
            case .disabled:
                SidebarView(rules: $rulesManager.rules.filter({ !$0.enabled }), rulesManager: _rulesManager, installationManager: _installationManager, filterManager: _filterManager)
            }
            
        } detail: {
            
            if let rule = rulesManager.selectedRule
            {
                // transform optional to non-optional
                let binding = Binding { rule } set: {
                    if (rulesManager.tryUpdateRule(rule: $0)) {
                        rulesManager.rulesChanged = true
                    }
                    
                }
                RuleView(rulesManager: _rulesManager, selectedRule: binding, isInUse: $rulesManager.filterEnabled)
            }
            else
            {
                Text("Select Rule")
            }
        }
    }
}

#Preview {
    ContentView(rulesManager: RulesManager(), installationManager: InstallationManager(), filterManager: FilterManager())
}
