//
//  NEFilterSocketFlowУчеутышщт.swift
//  NetworkApp
//
//  Created by user on 28.11.2024.
//

import NetworkExtension
import OSLog

extension NEFilterFlow {
    
    public var endpoint: String? {
        guard let socketFlow = self as? NEFilterSocketFlow,
              let endpoint = socketFlow.remoteEndpoint as? NWHostEndpoint
        else {
            return nil
        }
        
        return "\(endpoint.hostname):\(endpoint.port)"
    }
    
    public var hostname: String? {
        guard let socketFlow = self as? NEFilterSocketFlow,
              let endpoint = socketFlow.remoteHostname
        else {
            return nil
        }
        
        return endpoint
    }
    
    public var bundleID: String? {
        // Cast Data? to Data
        guard let tokenData: Data = self.sourceAppAuditToken else {
            os_log(OSLogType.error, "Failed to cast sourceAppAuditToken")
            return nil
        }
        
        // Map signed code information to codeObject
        var codeQuery: SecCode? = nil
        var err = SecCodeCopyGuestWithAttributes(nil, [
            kSecGuestAttributeAudit: tokenData
        ] as NSDictionary, [], &codeQuery)
        guard err == errSecSuccess else {
            return nil
        }
        
        // Convert info to a static code.
        var staticCodeQuery: SecStaticCode? = nil
        err = SecCodeCopyStaticCode(codeQuery!, [], &staticCodeQuery)
        guard err == errSecSuccess else {
            return nil
        }
        
        // Get code signing information
        var infoQuery: CFDictionary? = nil
        err = SecCodeCopySigningInformation(staticCodeQuery!, [], &infoQuery)
        guard err == errSecSuccess else {
            return nil
        }
        
        // Extract the bundle ID from plist.
        let info = infoQuery! as! [String:Any]
        guard let plist = info[kSecCodeInfoPList as String] as? [String:Any],
              let bundleID = plist[kCFBundleIdentifierKey as String] as? String
        else {
            return nil
        }
        
        return bundleID
    }
}
