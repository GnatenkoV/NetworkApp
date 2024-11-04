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
    @Binding var rulesSelection: Set<Rule>
    @ObservedObject var rulesManager: RulesManager
    
    init(rules: Binding<[Rule]>, rulesSelection: Binding<Set<Rule>>, rulesManager: ObservedObject<RulesManager>) {
        self._rules = rules
        self._rulesSelection = rulesSelection
        self._rulesManager = rulesManager
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
        
            if (rulesSelection.isEmpty == false)
            {
                Text("You selected \(rulesSelection.first!.title)")
            }
            
            List{
                Section("Rules") {}
            }
            .scrollDisabled(true)
            .frame(height: 20)
            .buttonStyle(PlainButtonStyle()).disabled(true)
            ScrollViewReader { proxy in
                List($rules, id:\.self, selection: $rulesSelection) { $rule in
                    Label(rule.title, systemImage: rule.enabled ? "togglepower" : "poweroff")
                        .tag(rule.id)
                    EmptyView()
                }
                .onChange(of: rulesSelection) { oldValue, newValue in
                    
                    if (newValue.count > 1)
                    {
                        let oldItemCopy = oldValue.first!
                        
                        let oldItem = rulesSelection.first(where: { $0.id == oldItemCopy.id})!
                        
                        self.rulesSelection.remove(oldItem)
                    }
                    
                    if (!rulesSelection.isEmpty)
                    {
                        self.rulesManager.changeSelection(rulesSelection.first!.id)
                    }
                }
                .onChange(of: rulesManager.selectedRuleIndex, {

                    
                    /*let index = rulesManager.getFilteredArraySelectedIndex(filterSelection: rulesManager.filterSelection)
                    let selectedRule = rules[index]
                    if (selectedRule.title.contains("Empty rule"))
                    {
                        self.rulesSelection.removeAll()
                        self.rulesSelection.insert(rules[rulesManager.getFilteredArraySelectedIndex(filterSelection: rulesManager.filterSelection)])
                        withAnimation {
                            proxy.scrollTo(selectedRule, anchor: .bottom)
                        }
                    }*/
                })
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: {

                }, label: {
                    Label("Add Rule", systemImage: "plus.circle")
                })
                .buttonStyle(.borderless)
                .foregroundColor(.accentColor)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#if DEBUG
struct SidebarView_Preview : PreviewProvider {
    @State static var rulesSelection = Set<Rule>()
    @State static var selectedRule: Rule?
    @ObservedObject static var rulesManager = RulesManager()
    
    static var previews: some View {
        SidebarView(rules: .constant(Rule.examples()),
                     rulesSelection: $rulesSelection, rulesManager: _rulesManager)
        .listStyle(.sidebar)
    }
    
}
#endif
