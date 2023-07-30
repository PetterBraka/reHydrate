//
//  DatabaseService.swift
//
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird
import DatabaseServiceInterface

public class Database: DatabaseType {
    public private(set) var  db: Blackbird.Database
    
    public init() {
        do {
            self.db = try .init(path: "reHydrate/db.sqlite")
        } catch {
            fatalError("Database couldn't be initialised")
        }
    }
}
