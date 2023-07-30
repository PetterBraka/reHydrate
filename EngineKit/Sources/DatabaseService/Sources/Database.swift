//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird
import DatabaseServiceInterface
import Foundation

public class Database: DatabaseType {
    public private(set) var  db: Blackbird.Database
    
    public init() {
        do {
            let filename = "db.sqlite"
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent(filename)
            self.db = try .init(path: fileURL.absoluteString)
        } catch {
            fatalError("Database couldn't be initialised - \(error)")
        }
    }
    
    public func close() {
        Task {
            await db.close()
        }
    }
}
