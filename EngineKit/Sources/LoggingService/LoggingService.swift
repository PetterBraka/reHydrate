//
//  LoggingService.swift
//
//
//  Created by Petter vang Brakalsvålet on 03/09/2023.
//

import os
import Foundation

public final class LoggingService {
    let logger: Logger
    
    public init(subsystem: String) {
        self.logger = Logger(subsystem: subsystem, category: "Engine")
    }
    
    public func debug(_ message: String, error: Error? = nil, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
    
    public func info(_ message: String, error: Error? = nil, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
    
    public func warning(_ message: String, error: Error? = nil, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
    
    public func error(_ message: String, error: Error, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
    
    public func trace(_ message: String, error: Error? = nil, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
    
    public func notice(_ message: String, error: Error? = nil, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
    
    public func critical(_ message: String, error: Error? = nil, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
    
    public func fault(_ message: String, error: Error, file: StaticString = #fileID) {
        log(level: .fault, message: message, error: error, file: file)
    }
}

extension LoggingService {
    private func log(level: OSLogType, message: String, error: Error?, file: StaticString) {
        if let error {
            let errorDescription = String(describing: error)
            let localizedError = (error as? LocalizedError)?.localizedDescription ?? "No description"
            logger.log(level: level,
                       "[\(file, privacy: .public)]\n-\t\(message, privacy: .public)\n-\tError: \(localizedError, privacy: .public) - \(errorDescription, privacy: .private)")
        } else {
            logger.log(level: level, "[\(file, privacy: .public)]\n-\t\(message, privacy: .public)")
        }
    }
}
