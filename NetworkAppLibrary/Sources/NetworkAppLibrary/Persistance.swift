import Foundation
import OSLog

public class Persistance {
    private static let applicationFolderPath = "/Library/Application Support/com.apriorit.networkextension"
    private let rulesPath: String
    private let persistanceJson: String
    
    public init(fileName: String = "rules.json")
    {
        self.persistanceJson = fileName
        self.rulesPath = Persistance.applicationFolderPath + "/" + fileName
    }
    
    public func createIfNotExists() {
        do {
            if (!FileManager.default.fileExists(atPath: Persistance.applicationFolderPath))
            {
                let directoryURL = URL(fileURLWithPath: Persistance.applicationFolderPath)
                try FileManager.default.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }

            if (!FileManager.default.fileExists(atPath: rulesPath))
            {
                let json = "[]"
                let rulesJsonUrl = URL(fileURLWithPath: rulesPath)
                
                try json.write(to: rulesJsonUrl, atomically: false, encoding: String.Encoding.utf8)
                
                // all users, all groups, all others
                let newMode: FileRights = [FileRights(rawValue: S_IRWXU), FileRights(rawValue: S_IRWXG), FileRights(rawValue: S_IRWXO)]
                // set read/write access for rules.json
                chmod(rulesPath, newMode.rawValue)
            }
        }
        catch
        {
            os_log(OSLogType.error, "Failed to create rules.json")
        }
    }
    
    public func loadRules() -> [Rule] {
        do {
            let rulesJsonUrl = URL(fileURLWithPath: rulesPath)
            let jsonData = try Data(contentsOf: rulesJsonUrl)
            
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode([Rule].self, from: jsonData)
        }
        catch
        {
            os_log(OSLogType.error, "Failed to read from rules.json")
        }
        
        return [Rule]()
    }
    
    public func saveRules(_ rules : [Rule]) -> Void {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(rules)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)!
            
            let rulesJsonUrl = URL(fileURLWithPath: rulesPath)
            try json.write(to: rulesJsonUrl, atomically: false, encoding: String.Encoding.utf8)
        }
        catch
        {
            os_log(OSLogType.error, "Failed to write to rules.json")
        }
    }
}
