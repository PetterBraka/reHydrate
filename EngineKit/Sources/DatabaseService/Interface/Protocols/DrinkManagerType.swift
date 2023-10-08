//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/10/2023.
//

public protocol DrinkManagerType {
    func createNewDrink(size: Double, container: String) async throws -> DrinkModel
    func edit(size: Double, of container: String) async throws -> DrinkModel
    
    func delete(_ drink: DrinkModel) async throws
    func deleteDrink(container: String) async throws
    func deleteAll() async throws
    
    func fetch(_ container: String) async throws -> DrinkModel
    func fetchAll() async throws -> [DrinkModel]
}
