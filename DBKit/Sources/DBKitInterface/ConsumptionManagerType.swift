//
//  ConsumptionManagerType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import Foundation

public protocol ConsumptionManagerType {
    @discardableResult
    func createEntry(date: Date, consumed: Double) throws -> ConsumptionModel
    
    func delete(_ entry: ConsumptionModel) async throws
    
    func fetchAll(at date: Date) async throws -> [ConsumptionModel]
    func fetchAll() async throws -> [ConsumptionModel]
}
