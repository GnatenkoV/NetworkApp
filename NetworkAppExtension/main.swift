//
//  main.swift
//  NetworkAppExtension
//
//  Created by user on 01.11.2024.
//

import Foundation
import NetworkExtension
import OSLog
import NetworkAppLibrary

os_log(OSLogType.info, "Start extension")

// create app folder
Persistance().createIfNotExists()

autoreleasepool {
    NEProvider.startSystemExtensionMode()
}

dispatchMain()
