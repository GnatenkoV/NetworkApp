import Foundation
import OSLog
import SystemExtensions

extension InstallationManager: OSSystemExtensionRequestDelegate
{
    @objc func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) -> Void {
        os_log("System extension request failed %@", error.localizedDescription)
        
        self.status = getExtensionStatus()
        
        if (self.uninstallingInProgress) {
            self.uninstallingInProgress = false
        }
    }
      
      
    @objc func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) -> Void {
        os_log("System extension requires user approval")
        
        self.status = getExtensionStatus()
    }
      
      
    @objc func request(_ request: OSSystemExtensionRequest,
                 actionForReplacingExtension existing: OSSystemExtensionProperties,
                 withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        os_log("Replacing extension: %@ %@", existing, ext)
        
        self.status = getExtensionStatus()
        
        return .replace
    }
      
      
    @objc func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) -> Void {
        os_log("System extension activating request result: %d", result.rawValue)
        
        self.status = getExtensionStatus()
        
        if (self.uninstallingInProgress) {
            self.uninstallingInProgress = false
            
            if (self.uninstallCallback != nil) {
                self.uninstallCallback!(self.status == .uninstalled)
            }
        }
    }
}
