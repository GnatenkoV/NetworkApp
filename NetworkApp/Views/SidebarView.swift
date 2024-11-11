//
//  SidebarView.swift
//  NetworkApp
//
//  Created by user on 01.11.2024.
//

import SwiftUI
import NetworkAppLibrary

struct SidebarView: View {
    @Binding var rules: [Rule]
    @ObservedObject var rulesManager: RulesManager
    @ObservedObject var installationManager: InstallationManager
    @ObservedObject var filterManager: FilterManager
    
    init(rules: Binding<[Rule]>, rulesManager: ObservedObject<RulesManager>, installationManager: ObservedObject<InstallationManager>, filterManager: ObservedObject<FilterManager>) {
        self._rules = rules
        self._rulesManager = rulesManager
        self._installationManager = installationManager
        self._filterManager = filterManager
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(selection: $rulesManager.filterSelection) {
                Section("Filters") {
                    ForEach(RuleSelection.allCases) { selection in
                        Label(selection.displayName, systemImage: selection.iconName)
                            .tag(selection)
                    }
                }
            }
            .frame(height: 120)
            .scrollDisabled(true)
            
            List{
                Section("Rules") {}
            }
            .scrollDisabled(true)
            .frame(height: 20)
            .buttonStyle(PlainButtonStyle()).disabled(true)
            
            ScrollViewReader { proxy in
                List($rules, id:\.self, selection: $rulesManager.selectedRule) { $rule in
                    Label(rule.title, systemImage: rule.enabled ? "togglepower" : "poweroff")
                        .tag(rule.id)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                self.rulesManager.removeRule(rule)
                            }
                        }
                    EmptyView()
                }
                .onChange(of: rulesManager.selectedRule) { _, newValue in
                    // must be an animation of scroll to item
                    if (newValue?.title == "")
                    {
                        withAnimation {
                            proxy.scrollTo(rulesManager.rules.last, anchor: .bottom)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack (alignment: .leading) {
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
                        .opacity(0.3)
                    
                    Button(action: {
                        let rule = self.rulesManager.addRule("", false)
                        self.rulesManager.changeSelection(rule: rule)
                        
                    }, label: {
                        Label("Add Rule", systemImage: "plus.circle")
                    })
                    .buttonStyle(.borderless)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 19)
                    
                    Label("Installed", systemImage: installationManager.status.iconName)
                        .help(Text(installationManager.status.tooltip))
                        .padding(.top, 4)
                        .padding(.leading, 19)
                    
                    Label("Filter status", systemImage: filterManager.status.iconName)
                        .help(Text(filterManager.status.tooltip))
                        .padding(.top, 4)
                        .padding(.leading, 19)
                        .padding(.bottom, 19)
                }
            }
        }
    }
}

#if DEBUG
struct SidebarView_Preview : PreviewProvider {
    @State static var rulesSelection: Rule? = Rule.emptyRule()
    @ObservedObject static var rulesManager = RulesManager()
    @ObservedObject static var installationManager = InstallationManager()
    @ObservedObject static var filterManager = FilterManager()
    
    static var previews: some View {
        SidebarView(rules: .constant(Rule.examples()), rulesManager: _rulesManager, installationManager: _installationManager, filterManager: _filterManager)
        .listStyle(.sidebar)
    }
    
}
#endif
