//
//  DatabaseType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird

public protocol DatabaseType {
    #if DEBUG
    var db: Blackbird.Database? { get }
    #endif
    
    func write<Element: BlackbirdModel>(_ element: Element) async throws
    
    func read<Element: BlackbirdModel>(
        matching: BlackbirdModelColumnExpression<Element>?,
        orderBy: BlackbirdModelOrderClause<Element>,
        limit: Int?
    ) async throws -> [Element]
    
    func delete<Element: BlackbirdModel>(_ element: Element) async throws
    func delete<Element: BlackbirdModel>(matching: BlackbirdModelColumnExpression<Element>) async throws
}
