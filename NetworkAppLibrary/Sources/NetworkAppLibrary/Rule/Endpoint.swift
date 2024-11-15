import Foundation

public struct Endpoint: Identifiable, Hashable, Codable {
    public var id = UUID()
    public var isIpAddress: Bool
    public var endpoint: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case isIpAddress = "isIpAddress"
        case endpoint = "endpoint"
    }
    
    public init(endpoint: String, isIpAddress: Bool) {
        self.endpoint = endpoint
        self.isIpAddress = isIpAddress
    }
}
