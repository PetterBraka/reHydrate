//
//  DatabaseError.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/07/2023.
//

import Foundation

public enum DatabaseError: Error {
    case noElementFound
}


extension DatabaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noElementFound:
            return "No element found in the database"
        }
    }
}
