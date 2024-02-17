//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/02/2024.
//

import OSLog

package final class LoggingService {
    private let logger: Logger
    private static let shared = LoggingService()
    
    private init() {
        logger = Logger(subsystem: "reHydrate", category: "DataBase")
    }
    
    static func log(level: OSLogType, _ message: String) {
        shared.logger.log(level: level, "\(message, privacy: .private)")
    }
}
