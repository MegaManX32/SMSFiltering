//
//  Logger.swift
//  SMSFiltering
//
//  Created by Vladislav Simovic on 11.12.24..
//

import Foundation
import os

final class Logger {
    
    enum Level {
        case info
        case warning
        case error
    }
    
    static let shared = Logger()
    private let log = OSLog(subsystem: "com.simke.SMSFiltering", category: "logging")
    
    func log(message: String, level: Level = .info) {
        switch level {
        case .info:
            os_log("%@", log: log, type: .info, message)
        case .warning:
            os_log("%@", log: log, type: .error, message)
        case .error:
            os_log("%@", log: log, type: .fault, message)
        }
    }
}
