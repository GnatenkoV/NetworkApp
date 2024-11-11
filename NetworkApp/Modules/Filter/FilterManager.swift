import Foundation
import NetworkExtension
import OSLog

public class FilterManager: NSObject, ObservableObject {
    @Published public var status = FilterStatus.stopped
    
    public override init() {
        super.init()
        updateStatus()
    }
    
    public func updateStatus() -> Void {
        if (NEFilterManager.shared().isEnabled) {
            self.status = FilterStatus.started
        } else {
            self.status = FilterStatus.stopped
        }
    }
    
    public func restart() -> Void {
        DispatchQueue.main.async {
            if (self.status != FilterStatus.stopped) {
                self.stop()
            }
            
            sleep(1)
            
            self.start()
        }
    }
    
    public func start() -> Void {
        self.status = FilterStatus.pending
        let filterManager = NEFilterManager.shared()
        
        filterManager.loadFromPreferences { loadError in
            DispatchQueue.main.async {
                if let error = loadError {
                    os_log(OSLogType.fault, "Failed to load the filter configuration: %@", error.localizedDescription)
                    self.status = FilterStatus.stopped
                    return
                }
                
                if filterManager.providerConfiguration == nil {
                    let config = NEFilterProviderConfiguration()
                    config.filterPackets = false
                    config.filterSockets = true
                    filterManager.providerConfiguration = config
                    filterManager.localizedDescription = "NetworkApp"
                }
                
                filterManager.isEnabled = true
                
                filterManager.saveToPreferences { saveError in
                    DispatchQueue.main.async {
                        if let error = saveError {
                            os_log("Failed to save the filter configuration: %@", error.localizedDescription)
                            self.status = FilterStatus.stopped
                            return
                        }
                        
                        self.status = FilterStatus.started
                    }
                }
            }
        }
    }
    
    public func stop() {
        self.status = FilterStatus.pending
        let filterManager = NEFilterManager.shared()

        filterManager.loadFromPreferences { loadError in
            DispatchQueue.main.async {
                if let error = loadError {
                    os_log(OSLogType.fault, "Failed to load the filter configuration: %@", error.localizedDescription)
                    self.status = FilterStatus.started
                    return
                }
                
                filterManager.isEnabled = false
                
                filterManager.saveToPreferences { saveError in
                    DispatchQueue.main.async {
                        if let error = saveError {
                            os_log("Failed to disable the filter configuration: %@", error.localizedDescription)
                            self.status = FilterStatus.started
                            return
                        }
                        
                        self.status = FilterStatus.stopped
                    }
                }
            }
        }
    }
}
