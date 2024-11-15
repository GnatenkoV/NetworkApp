import Foundation

public extension Rule {
    static func examples() -> [Rule] {
        let rule1 = Rule(title: "Safari", bundleID: "com.apple.Safari", enabled: true, endpoints: [Endpoint(endpoint: "google.com", isIpAddress: false), Endpoint(endpoint: "youtube.com", isIpAddress: false)])
        let rule2 = Rule(title: "Chrome", bundleID: "com.google.chrome", enabled: true, endpoints: [Endpoint(endpoint: "google.com", isIpAddress: false), Endpoint(endpoint: "youtube.com", isIpAddress: false), Endpoint(endpoint: "apple.com", isIpAddress: false)])
        return [rule1, rule2]
    }
    
    static func example() -> Rule {
        return Rule(title: "Safari", bundleID: "com.apple.Safari", enabled: true, endpoints: [Endpoint(endpoint: "google.com", isIpAddress: false), Endpoint(endpoint: "youtube.com", isIpAddress: false)])
    }
    
    static func emptyRule() -> Rule {
        return Rule(title: "No rule selected", bundleID: "-", enabled: true, endpoints: [Endpoint(endpoint: "", isIpAddress: false)])
    }
}
