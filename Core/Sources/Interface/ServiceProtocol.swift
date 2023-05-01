//
//  ServiceProtocol.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/04/2023.
//

import Foundation

public protocol ServiceProtocol {
    associatedtype DomainModel
    associatedtype DataModel
    func create(_ item: DomainModel) async throws -> DataModel
    func delete(_ item: DomainModel) async throws
    func save() async throws
    func getElement(for date: Date) async throws -> DataModel
    func getElement(with id: UUID) async throws -> DataModel
    func getLatestElement() async throws -> DataModel
    func getAll() async throws -> [DataModel]
}
