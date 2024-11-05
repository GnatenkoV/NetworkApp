//
//  AddRuleView.swift
//  NetworkApp
//
//  Created by user on 01.11.2024.
//

import SwiftUI
import NetworkAppLibrary

struct RuleView: View {
    @ObservedObject var rulesManager: RulesManager
    @Binding var isInUse: Bool
    @Binding var selectedRule: Rule
    
    init(rulesManager: ObservedObject<RulesManager>, selectedRule: Binding<Rule>, isInUse: Binding<Bool>)
    {
        self._isInUse = isInUse
        self._rulesManager = rulesManager
        self._selectedRule = selectedRule
    }
    
    var body: some View {
        Grid (alignment: .leading) {
            GridRow {
                Text("Title")
                    .gridCellAnchor(.leading)
                TextField("", text: self.$selectedRule.title)
                    .frame(width: 140)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(5)
                
            }
            
            GridRow {
                Text("BundleID")
                    .gridCellAnchor(.leading)
                TextField("", text: self.$selectedRule.bundleID)
                    .frame(width: 140)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(5)
                    .gridCellAnchor(.leading)
                    .gridCellColumns(1)
            }
            
            GridRow {
                List(self.selectedRule.endpoints.indices, id:\.self) { index in
                    HStack {
                        Button( action: {
                            selectedRule.endpoints.remove(at: index)
                        }, label: {
                            Image(systemName: "minus.circle")
                                .imageScale(.medium)
                                .frame(width: 10, height: 18)
                        })
                        .buttonStyle(.borderless)
                        .foregroundColor(.accentColor)
                        
                        TextField("", text: self.$selectedRule.endpoints[index])
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(2)
                    }
                    EmptyView()
                }
                .padding(.leading, 0)
                .cornerRadius(12)
                .listStyle(.sidebar)
                .gridCellColumns(3)
                .safeAreaInset(edge: .bottom) {
                    Button(action: {
                        self.selectedRule.endpoints.append("")
                    }, label: {
                        Label("Add endpoint", systemImage: "plus.circle")
                    })
                    .buttonStyle(.borderless)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            GridRow {
                Toggle("Enabled", isOn: self.$selectedRule.enabled)
                    .gridCellAnchor(.leading)
                    .gridCellColumns(1)
                
            }
        }
        .padding(10)
    }
}
    
#if DEBUG
struct RuleView_Preview : PreviewProvider {
    @ObservedObject static var rulesManager : RulesManager = RulesManager()
    @State static var isInUse = false
    
    static var previews: some View {
        if let rule = rulesManager.selectedRule
        {
            // transform optional to non-optional
            let binding = Binding { rule } set: { rulesManager.selectedRule = $0 }
            RuleView(rulesManager: _rulesManager, selectedRule: binding, isInUse: $isInUse)
        }
        else
        {
            Text("Select rule")
        }
    }
}
#endif
