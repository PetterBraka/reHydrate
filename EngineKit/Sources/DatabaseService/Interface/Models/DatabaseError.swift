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
}


extension DatabaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .openDB:
            return "Unable to open the database"
        case .noElementFound:
            return "No element found in the database"
        case .creatingElement:
            return "Can't create new element"
        case .updatingElement:
            return "Couldn't write updated element"
        case .deletingElement:
            return "Couldn't delete element"
        }
    }
}
