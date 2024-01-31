//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation
import Blackbird
import PortsInterface
import LoggingService

public class Database: DatabaseType {
    private let logger: LoggingService
    
    private let path: String
    
    #if DEBUG
    public var db: Blackbird.Database?
    #endif
    
    public init(logger: LoggingService) {
        self.logger = logger
        do {
            // Checks if tests are being ran and changes the DB path to be in a `temporaryDirectory`
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                self.path = FileManager
                    .default
                    .temporaryDirectory
                    .appendingPathComponent("db.sqlite")
                    .absoluteString
            } else {
                self.path = try FileManager
                    .default
                    .url(for: .documentDirectory,
                         in: .userDomainMask,
                         appropriateFor: nil,
                         create: true)
                    .appendingPathComponent("db.sqlite")
                    .absoluteString
            }
            logger.debug("DB path - \(self.path)")
        } catch {
            let message = "Path to database couldn't be defined"
            logger.critical(message, error: error)
            fatalError(message)
        }
    }
    
    func openDb() throws -> Blackbird.Database {
        do {
            let db = try Blackbird.Database(path: path)
            #if DEBUG
            self.db = nil
            self.db = db
            #endif
            return db
        } catch {
            logger.error("DB couldn't be opened", error: error)
            throw error
        }
    }
    
    func close(_ db: Blackbird.Database) async {
        await db.close()
    }
    
    public func write<Element: BlackbirdModel>(_ element: Element) async throws {
        let db = try openDb()
        try await element.write(to: db)
        await close(db)
    }
    
    public func read<Element: BlackbirdModel>(
        matching: BlackbirdModelColumnExpression<Element>?,
        orderBy: BlackbirdModelOrderClause<Element>,
        limit: Int?
    ) async throws -> [Element] {
        let db = try openDb()
        let elements = try await Element.read(from: db, matching: matching, orderBy: orderBy, limit: limit)
        await close(db)
        return elements
    }
    
    public func delete<Element: BlackbirdModel>(_ element: Element) async throws {
        let db = try openDb()
        try await element.delete(from: db)
        await close(db)
    }
    
    public func delete<Element: BlackbirdModel>(matching: BlackbirdModelColumnExpression<Element>) async throws {
        let db = try openDb()
        try await Element.delete(from: db, matching: matching)
        await close(db)
    }
    
    public func deleteAll<Element: BlackbirdModel>(_ element: Element) async throws {
        let db = try openDb()
        try await Element.delete(from: db, matching: .all)
        await close(db)
    }
}
