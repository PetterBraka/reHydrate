//
//  ServiceProtocol.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    associatedtype DomainModel
    associatedtype DataModel
    func create(_ item: DomainModel) async throws
    func delete(_ item: DomainModel) async throws
    func save() async throws
    func getElement(for date: Date) async throws -> DataModel
    func getLatestElement() async throws -> DataModel
    func getAll() async throws -> [DataModel]
}
