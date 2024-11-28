import Foundation
import OSLog

public class ExtensionUtils {
    public static func getExtensionStatus(extensionBundleId: String) -> ExtensionStatus {
        do {
            let url = URL(fileURLWithPath: "/Library/SystemExtensions/db.plist")
            let data = try Data(contentsOf: url)
            
            let decoder = PropertyListDecoder()
            let list = try! decoder.decode(ExtensionsPropertyList.self, from: data)
            
            for ext in list.extensions
            {
                if (ext.identifier != extensionBundleId) {
                    continue
                }
                
                if (ext.state == "activated_enabled") {
                    return .installed
                }
                else if (ext.state == "activated_waiting_for_user")
                {
                    return .wait_approve
                }
            }
        }
        catch let error
        {
            os_log(OSLogType.info, "%{public}@", error.localizedDescription)
        }
        
        return .uninstalled
    }
}
