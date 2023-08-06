//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird
import DatabaseServiceInterface
import OSLog

public class Database: DatabaseType {
    private let logger = Logger(subsystem: "engine.databaseService", category: "database")
    private var db: Blackbird.Database?
    
    public private(set) var path: String
    
    public init() {
        do {
            self.path = try FileManager
                .default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("db.sqlite")
                .absoluteString
            logger.debug("DB path - \(self.path)")
        } catch {
            fatalError("Path to database couldn't be deffined - \(error)")
        }
    }
    
    public func openDb() throws -> Blackbird.Database {
        if let db {
            return db
        }
        do {
            let db = try Blackbird.Database(path: path)
            self.db = db
            return db
        } catch {
            logger.error("DB couldn't be opened - \(error.localizedDescription)")
            throw error
        }
    }
    
    public func close(_ db: Blackbird.Database) async {
        await db.close()
        self.db = nil
    }
    }
}
