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
    
    @State private var title: String
    @State private var bundleID: String
    @State private var enabled: Bool
    
    init(rulesManager: ObservedObject<RulesManager>, isInUse: Binding<Bool>)
    {
        self._isInUse = isInUse
        self._rulesManager = rulesManager
        
        let rule = rulesManager.wrappedValue.rules[rulesManager.wrappedValue.selectedRuleIndex]
        
        self.enabled = rule.enabled
        self.title = rule.title
        self.bundleID = rule.bundleID
    }
    
    var body: some View {
        Grid{
            GridRow {
                Text("Title")
                TextField("", text: self.$title)
                .frame(width: 140)
                .multilineTextAlignment(.leading)
            }
            
            GridRow {
                Text("BundleID")
                TextField("", text: self.$bundleID)
                .frame(width: 140)
                .multilineTextAlignment(.leading)
            }
            
            GridRow {
                Toggle("Enabled", isOn: self.$enabled)
                    .gridCellColumns(1)
                    
            }
            
            GridRow {
                Button(action: {
                    rulesManager.rules[rulesManager.selectedRuleIndex].title = self.title
                    rulesManager.rules[rulesManager.selectedRuleIndex].enabled = self.enabled
                    rulesManager.rules[rulesManager.selectedRuleIndex].bundleID = self.bundleID
                }, label: {
                    Text("Save")
                })
                .gridCellColumns(2)
                .gridColumnAlignment(.leading)
                .gridCellAnchor(.leading)
            }
        }
        .padding(10)
        .onChange(of: self.rulesManager.selectedRuleIndex, {
            let rule = rulesManager.rules[rulesManager.selectedRuleIndex]
            
            self.enabled = rule.enabled
            self.title = rule.title
            self.bundleID = rule.bundleID
        })
    }
}

#if DEBUG
struct RuleView_Preview : PreviewProvider {
    @ObservedObject static var ruleManager : RulesManager = RulesManager()
    @State static var isInUse = false
    
    static var previews: some View {
        RuleView(rulesManager: _ruleManager, isInUse: $isInUse)
    }
    
}
#endif
