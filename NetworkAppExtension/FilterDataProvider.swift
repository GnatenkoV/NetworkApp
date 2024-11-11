//
//  FilterDataProvider.swift
//  NetworkAppExtension
//
//  Created by user on 01.11.2024.
//

import NetworkExtension
import OSLog
import NetworkAppLibrary

class FilterDataProvider: NEFilterDataProvider {
    private var persistance = Persistance()
    private var rules = [Rule]()
    
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        os_log(OSLogType.info, "Start filter")
        
        self.rules = persistance.loadRules()
        
        var filterRules = [NEFilterRule]()
        var usedEndpoints = [String]()
        
        for i in 0..<rules.count {
            let rule = rules[i]
            
            if (!rule.enabled) {
                continue
            }
            
            for j in 0..<rule.endpoints.count {
                let endpoint = rule.endpoints[j]
                var hostConf: NWHostEndpoint
                
                if (usedEndpoints.contains(endpoint.endpoint)) {
                    continue
                }
                
                usedEndpoints.append(endpoint.endpoint)
                
                os_log(OSLogType.info, "Rule added %{public}@", endpoint.endpoint)
                
                if (Utils.isDomain(address: endpoint.endpoint) && !endpoint.isIpAddress) {
                    hostConf = NWHostEndpoint(hostname: endpoint.endpoint, port: "0")
                } else {
                    let pair = Utils.parseAddressAndPort(address: endpoint.endpoint)
                    
                    hostConf = NWHostEndpoint(hostname: pair.0, port: pair.1)
                }
                
                let networkRule = NENetworkRule(remoteNetwork: hostConf,
                                                remotePrefix: 0,
                                                localNetwork: nil,
                                                localPrefix: 0,
                                                protocol: .any,
                                                direction: .any)
                
                filterRules.append(NEFilterRule(networkRule: networkRule, action: .filterData))
            }
            
            // Allow all flows that do not match the filter rules.
            let filterSettings = NEFilterSettings(rules: filterRules, defaultAction: .allow)
            
            apply(filterSettings) { error in
                if let applyError = error {
                    os_log(OSLogType.fault, "Failed to apply filter settings: %@", applyError.localizedDescription)
                }
                completionHandler(error)
            }
        }
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        
        os_log(OSLogType.info, "Stop filter")
        // Add code to clean up filter resources.
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
        guard let socketFlow = flow as? NEFilterSocketFlow,
              let remoteEndpoint = socketFlow.remoteEndpoint as? NWHostEndpoint,
              let localEndpoint = socketFlow.localEndpoint as? NWHostEndpoint
        else {
            return .allow()
        }
        
        let bundleId = Utils.bundleIdFromDescription(flow.description)
        let hostname = Utils.hostnameFromDescription(flow.description)
        
        os_log(OSLogType.info, "Got a new flow with local endpoint %{public}@ %{public}@, remote endpoint %{public}@, bundleId: %{public}@, description: %{public}@", localEndpoint, remoteEndpoint, hostname, bundleId, flow.description)
        
        Task.detached {
            guard let filteredRules = self.rules.filter({
                if (!$0.enabled) {
                    return false
                }
                
               return $0.bundleID == bundleId
            }) as [Rule]? else {
                os_log(OSLogType.info, "Allowed, didn't find")
                self.resumeFlow(flow, with: NEFilterNewFlowVerdict.allow())
                return
            }
            
            var isIncluded = false
            
            for rule in filteredRules {
                if (rule.endpoints.contains(where: {
                    if ($0.isIpAddress && $0.endpoint == "\(remoteEndpoint.hostname):\(remoteEndpoint.port)") {
                        return true
                    } else if (!$0.isIpAddress && hostname.contains($0.endpoint)) {
                        return true
                    }
                    return false
                })) {
                    isIncluded = true
                    break
                }
            }
            
            let verdict = isIncluded ? NEFilterNewFlowVerdict.drop() : NEFilterNewFlowVerdict.allow()
            
            if (isIncluded) {
                os_log(OSLogType.info, "Denied")
            } else {
                os_log(OSLogType.info, "Allowed")
            }
            
            self.resumeFlow(flow, with: verdict)
        }
        
        return .pause()
    }
}
