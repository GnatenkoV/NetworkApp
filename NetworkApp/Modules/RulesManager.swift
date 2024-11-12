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
    @Published public var rulesChanged = false
    
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
        
        self.rulesChanged = true
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
    
    public func tryUpdateRule(rule: Rule) -> Bool {
        var updated = false
        for i in 0..<rules.count {
            if (rules[i].id == rule.id) {
                updated = Rule.update(ruleOut: &rules[i], ruleIn: rule)
                
                changeSelection(rule: rule)
                
                break
            }
        }
        return updated
    }
    
    public func loadRules() -> Void {
        self.rules = persistance.loadRules()
        self.selectedRule = nil
        self.rulesChanged = false
    }
    
    public func saveRules() -> Void {
        persistance.saveRules(self.rules)
        self.rulesChanged = false
    }
}
