//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/02/2024.
//

import SwiftData
import Foundation

public protocol DatabaseType: Sendable {
    func insert<Model: PersistentModel & Sendable>(_ model: Model) async
    func delete<Model: PersistentModel & Sendable>(_ model: Model) async
    func save() async throws
    func read<Element: PersistentModel & Sendable>(
        matching: Predicate<Element>?,
        sortBy: [SortDescriptor<Element>],
        limit: Int?
    ) async throws -> [Element]
}
