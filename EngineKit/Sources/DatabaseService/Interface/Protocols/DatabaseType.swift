//
//  DatabaseType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird

public protocol DatabaseType {
    var path: String { get }
    
    func openDb() throws -> Blackbird.Database
    func close(_ db: Blackbird.Database) async
}
