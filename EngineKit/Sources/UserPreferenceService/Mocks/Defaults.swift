//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/04/2024.
//

extension Optional where Wrapped == Decodable {
    nonisolated(unsafe) static let `default`: Wrapped? = nil
}
