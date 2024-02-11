//
//  DatabaseError.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

import Foundation

public enum DatabaseError: Error {
    case openDB
    case noElementFound
    case creatingElement
    case updatingElement
    case deletingElement
    case couldNotMapElement
    case predicateCouldNotBeCreated
}


extension DatabaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .openDB:
            "Unable to open the database"
        case .noElementFound:
            "No element found in the database"
        case .creatingElement:
            "Can't create new element"
        case .updatingElement:
            "Couldn't write updated element"
        case .deletingElement:
            "Couldn't delete element"
        case .couldNotMapElement:
            "Couldn't map to element"
        case .predicateCouldNotBeCreated:
            "Predicate couldn't be created"
        }
    }
}
