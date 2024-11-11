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
    @Published public var filterSelection: RuleSelection = RuleSelection.all
    @Published public var selectedRule: Rule?
    
    private var persistance : Persistance
    
    override init() {
        self.installedApplicationBundleIds = [String]()
        self.persistance = Persistance()
        self.rules = persistance.loadRules()
        self.networkFilterEnabled = false
        super.init()
        
        self.initBundleIds()
        
        let bundleId = "com.apple.Safari"
        let hostname = "youtube.com"
        let port = "433"
        
        guard let filteredRules = self.rules.filter({
            if ($0.enabled) {
                return true
            }
            
           return $0.bundleID == bundleId
        }) as [Rule]? else {
            os_log(OSLogType.info, "Allowed, didn't find")
            //self.resumeFlow(flow, with: NEFilterNewFlowVerdict.allow())
            return
        }
        
        var isIncluded = false
        
        for rule in filteredRules {
            if (rule.endpoints.contains(where: {
                if ($0.isIpAddress && $0.endpoint == "\(hostname):\(port)") {
                    return true
                } else if (!$0.isIpAddress && $0.endpoint.contains(hostname)) {
                    return true
                }
                return false
            })) {
                isIncluded = true
                break
            }
        }
    }
    
    private func initBundleIds() -> Void {
        // guard instead of do-try-catch
        guard let enumerator = FileManager.default.enumerator(
            at: URL(filePath: "/Applications"),
            includingPropertiesForKeys: nil,
            options: [.skipsPackageDescendants]
        ) else { return }
        
        // saving the bundleId to a list
        self.installedApplicationBundleIds = enumerateApplications(directoryEnumerator: enumerator)
    }
    
    private func enumerateApplications(directoryEnumerator: FileManager.DirectoryEnumerator) -> [String] {
        var applications = [String]()
        
        for case let url as URL in directoryEnumerator {
            guard let bundle = Bundle(url: url) else {
                continue
            }
            if (bundle.bundleIdentifier != nil) {
                applications.append(bundle.bundleIdentifier!)
            }
            else
            {
                let enumerator = FileManager.default.enumerator(
                    at: url,
                    includingPropertiesForKeys: nil,
                    options: [.skipsPackageDescendants])
                // doesn't work because have no rights to see apps
                let res = enumerateApplications(directoryEnumerator: enumerator!)
                
                applications.append(contentsOf: res)
            }
        }
        
        return applications
    }
    
    public func addRule(_ rule: Rule) -> Void {
        rules.append(rule)
    }
    
    public func addRule(_ title: String, _ enabled: Bool = false) -> Rule {
        let rule = Rule(title: title, bundleID: "", enabled: enabled, endpoints: [])
        
        addRule(rule)
        
        return rule
    }
    
    public func changeSelection(rule: Rule?, index: Int = -1) -> Void {
        var ruleIndex: Int = index
        if (ruleIndex < 0)
        {
            for i in 0..<rules.count {
                if (rules[i].id == rule?.id) {
                    ruleIndex = i
                    break
                }
            }
        }
        
        if (ruleIndex >= 0)
        {
            self.selectedRule = rules[ruleIndex]
        }
    }
    
    public func removeRule(_ rule: Rule) -> Void {
        self.rules.removeAll(where: { $0.id == rule.id })
    }
    
    public func tryUpdateRule(rule: Rule) {
        for i in 0..<rules.count {
            if (rules[i].id == rule.id) {
                Rule.update(ruleOut: &rules[i], ruleIn: rule)
                
                changeSelection(rule: rule)
                
                break
            }
        }
        
    }
    
    public func loadRules() -> Void {
        self.rules = persistance.loadRules()
        self.selectedRule = nil
    }
    
    public func saveRules() -> Void {
        persistance.saveRules(self.rules)
    }
}
