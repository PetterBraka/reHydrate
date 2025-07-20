//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation
import SwiftData
import LoggingKit
import DBKitInterface

public enum Database {
    
    /// Creates a ModelContainer at the path specified. 
    /// - Parameters:
    ///   - path: The path of the db. `FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)`
    public static func createContainer(path: URL?, inMemory: Bool = false, schema: Schema) -> ModelContainer {
        let config: ModelConfiguration
        
        if inMemory {
            config = .init(isStoredInMemoryOnly: true)
        } else if let path {
            config = .init(url: path.appendingPathComponent("reHydrate.sqlite"))
        } else {
            fatalError("Failed to create shared file container.")
        }
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to load persistent model container: \(error.localizedDescription)")
        }
    }
}
