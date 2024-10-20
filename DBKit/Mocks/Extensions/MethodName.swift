//
//  Untitled.swift
//  DBKit
//
//  Created by Petter vang Brakalsvålet on 20/10/2024.
//

extension DBKitMocks.DatabaseSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .open: "open"
        case .read: "read"
        case .save: "save"
        }
    }
}
