import Foundation
import NetworkExtension
import OSLog

public class FilterManager: NSObject, ObservableObject {
    @Published public var status: FilterStatus = .stopped
    
    public override init() {
        super.init()
        updateStatus()
    }
    
    public func updateStatus() -> Void {
        self.status = .pending
        
        let filterManager = NEFilterManager.shared()
        filterManager.loadFromPreferences { loadError in
            DispatchQueue.main.async {
                if let error = loadError {
                    os_log(OSLogType.fault, "Failed to load the filter configuration: %@", error.localizedDescription)
                    self.status = .stopped
                    return
                }
                
                if (NEFilterManager.shared().isEnabled) {
                    self.status = .started
                } else {
                    self.status = .stopped
                }
            }
        }
    }
    
    public func restart() -> Void {
        if (self.status != .stopped) {
            self.stop({ self.start() })
        } else {
            self.start()
        }
    }
    
    public func start(_ callback: (() -> Void)? = nil) -> Void {
        self.status = .pending
        let filterManager = NEFilterManager.shared()
        
        filterManager.loadFromPreferences { loadError in
            DispatchQueue.main.async {
                if let error = loadError {
                    os_log(OSLogType.fault, "Failed to load the filter configuration: %@", error.localizedDescription)
                    self.status = .stopped
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
                            os_log(OSLogType.fault, "Failed to save the filter configuration: %@", error.localizedDescription)
                            self.status = .stopped
                            callback?()
                            return
                        }
                                                
                        self.status = .started
                        callback?()
                    }
                }
            }
        }
    }
    
    public func stop(_ callback: (() -> Void)? = nil) {
        self.status = .pending
        let filterManager = NEFilterManager.shared()

        filterManager.loadFromPreferences { loadError in
            DispatchQueue.main.async {
                if let error = loadError {
                    os_log(OSLogType.fault, "Failed to load the filter configuration: %@", error.localizedDescription)
                    self.status = .started
                    return
                }
                
                filterManager.isEnabled = false
                
                filterManager.saveToPreferences { saveError in
                    DispatchQueue.main.async {
                        if let error = saveError {
                            os_log(OSLogType.fault, "Failed to disable the filter configuration: %@", error.localizedDescription)
                            self.status = .started
                            callback?()
                            return
                        }
                        
                        self.status = .stopped
                        callback?()
                    }
                }
            }
        }
    }
}
