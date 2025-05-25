//
//  Untitled.swift
//  EngineKit
//
//  Created by Petter vang Brakalsvålet on 30/03/2025.
//

public struct AnyHashableAndSendable: @unchecked Sendable, Hashable {
    private let wrapped: AnyHashable
    
    init(wrapped: some Hashable & Sendable) {
        self.wrapped = .init(wrapped)
    }
}
