//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/02/2024.
//

import Foundation

extension Bool {
    static let `default` = false
}

extension Optional where Wrapped == URL {
    static let `default`: Wrapped? = nil
}
