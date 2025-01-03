import Foundation

public struct Endpoint: Identifiable, Hashable, Codable {
    public var id = UUID()
    public var isIpAddress: Bool
    public var endpoint: String
    
    public init(endpoint: String, isIpAddress: Bool) {
        self.endpoint = endpoint
        self.isIpAddress = isIpAddress
    }
}
