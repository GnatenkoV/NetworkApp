//
//  RulesManager.swift
//  NetworkApp
//
//  Created by user on 01.11.2024.
//

import Foundation
import OSLog
import NetworkAppLibrary

public class RulesManager: NSObject, ObservableObject {
    @Published public var rules: [Rule]
    @Published public var installedApplicationBundleIds: [String]
    @Published public var networkFilterEnabled: Bool
    @Published public var filterEnabled: Bool = false
    @Published public var selectedRuleIndex: Int = 0
    @Published public var filterSelection: RuleSelection = RuleSelection.all
    
    private var persistance : Persistance
    
    override init() {
        self.installedApplicationBundleIds = [String]()
        self.persistance = Persistance()
        self.rules = persistance.loadRules()
        self.networkFilterEnabled = false
        super.init()
        
        self.initBundleIds()
    }
    
    private func initBundleIds() -> Void {
        // guard instead of do-try-catch
        guard let enumerator = FileManager.default.enumerator(
            at: URL(filePath: "/Applications"),
            includingPropertiesForKeys: nil,
            options: [.skipsPackageDescendants]
        ) else { return }
        
        // saving the bundleId to a list
        for case let url as URL in enumerator {
            guard let bundle = Bundle(url: url) else { continue }
            if (bundle.bundleIdentifier != nil) {
                installedApplicationBundleIds.append(bundle.bundleIdentifier!)
            }
        }
    }
    
    public func addRule(_ rule: Rule) -> Void {
        rules.append(rule)
    }
    
    public func addRule(_ title: String, _ enabled: Bool = false) -> Rule {
        
        let rule = Rule(title: title, bundleID: "", enabled: enabled, endpoints: [])
        
        addRule(rule)
        
        return rule
    }
    
    public func removeRule(_ rule: Rule) -> Void {
        self.rules.removeAll(where: { $0.id == rule.id })
    }
    
    public func changeSelection(_ id: UUID) -> Void {
        guard let index = rules.firstIndex(where: { $0.id == id}) else { return }
        
        self.selectedRuleIndex = index
    }
    
    public func getFilteredArraySelectedIndex(filterSelection: RuleSelection) -> Int
    {
        var index = 0
        
        for i in 0..<rules.count {
            switch (filterSelection) {
            case .all:
                return self.selectedRuleIndex
            case .enabled:
                if (rules[i].enabled)
                {
                    index += 1
                }
                break
            case .disabled:
                if (!rules[i].enabled)
                {
                    index += 1
                }
                break
            }
            
            if (rules[i].id == rules[selectedRuleIndex].id)
            {
                return index - 1
            }
        }
        
        return 0
    }
    
    private func loadRules() -> Void {
        self.rules = persistance.loadRules()
    }
    
    private func saveRules() -> Void {
        persistance.saveRules(self.rules)
    }
}
