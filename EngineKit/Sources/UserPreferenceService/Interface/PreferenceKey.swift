//
//  PreferenceKey.swift
//  EngineKit
//
//  Created by Petter vang Brakalsvålet on 06/10/2024.
//

public struct PreferenceKey: Equatable, Sendable {
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
}
