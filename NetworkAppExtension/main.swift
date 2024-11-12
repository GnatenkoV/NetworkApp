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

// create app folder + rules.json
Persistance().createIfNotExists()

autoreleasepool {
    NEProvider.startSystemExtensionMode()
}

dispatchMain()
