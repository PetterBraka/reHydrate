//
//  ContainerManagerType.swift
//
//
//  Created by Petter vang Brakalsvålet on 20/08/2023.
//

public protocol ContainerManagerType {
    typealias Entry = ContainerModel
    
    @discardableResult
    func createEntry(of size: Double) async throws -> Entry
    
    func update(_ entry: Entry, newSize: Double) async throws -> Entry
    func delete(_ entry: Entry) async throws
    
    func fetchAll() async throws -> [Entry]
}
