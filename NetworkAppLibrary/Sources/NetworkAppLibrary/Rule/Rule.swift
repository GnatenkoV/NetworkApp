import Foundation

public struct Rule : Identifiable, Hashable, Codable {
    public var id = UUID()
    public var title: String
    public var enabled: Bool
    public var bundleID: String
    public var endpoints: Array<Endpoint>
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case enabled = "enabled"
        case bundleID = "bundleID"
        case endpoints = "endpoints"
    }
    
    public init(title: String, bundleID: String, enabled: Bool, endpoints: [Endpoint] = []) {
        self.title = title
        self.enabled = enabled
        self.endpoints = endpoints
        self.bundleID = bundleID
    }
    
    public init(rule: Rule)
    {
        self.title = rule.title
        self.enabled = rule.enabled
        self.endpoints = rule.endpoints
        self.bundleID = rule.bundleID
    }
    
    static public func update(ruleOut: inout Rule, ruleIn: Rule) -> Bool
    {
        let updated = ruleOut.title != ruleIn.title || ruleOut.enabled != ruleIn.enabled || ruleOut.endpoints != ruleIn.endpoints || ruleOut.bundleID != ruleIn.bundleID
        
        ruleOut.title = ruleIn.title
        ruleOut.enabled = ruleIn.enabled
        ruleOut.endpoints = ruleIn.endpoints
        ruleOut.bundleID = ruleIn.bundleID
        
        return updated
    }
}
