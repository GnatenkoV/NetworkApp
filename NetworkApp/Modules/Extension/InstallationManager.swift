import Foundation
import SystemExtensions
import OSLog

class InstallationManager: NSObject, ObservableObject
{
    private let extensionBundleId: String = "com.apriorit.networkextension.sysext"
    private var currentRequest: OSSystemExtensionRequest?
    
    @Published public var status = ExtensionStatus.uninstalled
    @Published public var uninstallingInProgress = false
    
    override init()
    {
        super.init()

        self.status = getExtensionStatus()
        
        os_log(OSLogType.debug, "args: \(CommandLine.arguments)")
        
        if (CommandLine.arguments.contains("-uninstall"))
        {
            uninstallingInProgress = true
            
            if (status == ExtensionStatus.installed || status == ExtensionStatus.wait_approve)
            {
                uninstall()
            }
            else
            {
                exit(0)
            }
        }
    }
    
    public func getExtensionStatus() -> ExtensionStatus
    {
        do
        {
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
                    return ExtensionStatus.installed
                }
                else if (ext.state == "activated_waiting_for_user")
                {
                    return ExtensionStatus.wait_approve
                }
            }
        }
        catch let error
        {
            os_log("%@", error.localizedDescription)
        }
        
        return ExtensionStatus.uninstalled
    }
    
    public func install() -> Void
    {
        status = ExtensionStatus.uninstalled
        
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionBundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        currentRequest = request
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    public func uninstall() -> Void
    {
        status = ExtensionStatus.uninstalled
        
        let request = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionBundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
}
