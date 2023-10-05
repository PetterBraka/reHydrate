//
//  ContainerManagerType.swift
//
//
//  Created by Petter vang Brakalsvålet on 20/08/2023.
//

public protocol ContainerManagerType {
    func create(size: Int) async throws -> ContainerModel
    
    func update(oldSize: Int, newSize: Int) async throws -> ContainerModel
    func delete(size: Int) async throws
    
    func fetchAll() async throws -> [ContainerModel]
}
