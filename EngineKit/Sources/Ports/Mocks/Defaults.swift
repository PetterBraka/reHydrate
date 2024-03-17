//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/02/2024.
//

import Foundation
import PortsInterface

extension Bool {
    static let `default` = false
}

extension Optional where Wrapped == URL {
    static let `default`: Wrapped? = nil
}

extension Result where Success == Double, Failure == Error {
    static let `default`: Result<Success, Failure> = .success(0)
}

extension Result where Success == [Double], Failure == Error {
    static let `default`: Result<Success, Failure> = .success([])
}
