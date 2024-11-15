import Foundation

public class Utils {
    public static func isDomain(address: String) -> Bool {
        
        let range = NSRange(location: 0, length: address.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^((?:[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])[.]){3}(?:[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]):(?!0)(\\d{1,4}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$")
        
        return regex.firstMatch(in: address, options: [], range: range) == nil
    }
    
    public static func parseAddressAndPort(address: String) -> (String, String) {
        if (isDomain(address: address)) {
            return ("", "")
        }
        
        let elements = address.components(separatedBy: ":")
        
        if (elements.count == 2)
        {
            return (elements[0], elements[1])
        }
        
        return ("", "")
    }
    
    private static func parseValueFromDescription(_ description: String, _ key: String) -> String {
        if (description.isEmpty) {
            return ""
        }
        
        let lines = description.split(separator: "\n")
        
        var value = ""
        
        for i in 0..<lines.count {
            let line = lines[i]
            
            if (line.contains(key)) {
                let elements = line.split(separator: "=")
                
                if (elements.count == 2) {
                    value = String(elements[1])
                }
                break
            }
        }
        
        return value
    }
    
    public static func hostnameFromDescription(_ description: String) -> String {
        var hostname = parseValueFromDescription(description, "remoteHostname")
        
        if (!hostname.isEmpty) {
            hostname.replace(" ", with: "")
            return hostname
        }

        return hostname
    }
    
    public static func bundleIdFromDescription(_ description: String) -> String {
        var bundleId = parseValueFromDescription(description, "sourceAppIdentifier")
        
        if (!bundleId.isEmpty) {
            var tmp = String(bundleId).split(separator: "com")
            
            if (tmp.count >= 2) {
                tmp.remove(at: 0)
                bundleId = tmp.joined(separator: "com")
                if (tmp.count == 1) {
                    bundleId = "com" + bundleId
                }
            }
        }
        
        return bundleId
    }
}
