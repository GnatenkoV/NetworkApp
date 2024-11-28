import Foundation
import SystemExtensions
import OSLog

class InstallationManager: NSObject, ObservableObject {
    private let extensionBundleId: String = "com.apriorit.networkextension.sysext"
    private var currentRequest: OSSystemExtensionRequest?
    
    @Published public var status = ExtensionStatus.uninstalled
    @Published public var uninstallingInProgress = false
    
    public var uninstallCallback: ((_ result: Bool) -> Void)?
    
    override init() {
        super.init()

        self.status = getExtensionStatus()
        
        os_log(OSLogType.debug, "args: \(CommandLine.arguments)")
    }
    
    public func getExtensionStatus() -> ExtensionStatus {
        return ExtensionUtils.getExtensionStatus(extensionBundleId: extensionBundleId)
    }
    
    public func install() -> Void {
        status = .uninstalled
        
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionBundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        currentRequest = request
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    public func uninstall() -> Void {
        status = .wait_uninstall
        
        uninstallingInProgress = true
        
        let request = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionBundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
}
