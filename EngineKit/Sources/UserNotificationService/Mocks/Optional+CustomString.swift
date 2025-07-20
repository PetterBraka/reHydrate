//
//  Date+CustomString.swift
//  EngineKit
//
//  Created by Petter vang Brakalsvålet on 22/03/2025.
//

import Foundation

extension Optional: @retroactive CustomStringConvertible where Wrapped == Date {
    public var description: String {
        guard let self = self else { return "nil" }
        return "\(self.ISO8601Format())"
    }
}
