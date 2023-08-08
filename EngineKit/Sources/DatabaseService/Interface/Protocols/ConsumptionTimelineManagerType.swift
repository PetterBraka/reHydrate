//
//  ConsumptionTimelineManagerType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 07/08/2023.
//

import Foundation

public protocol ConsumptionTimelineManagerType {
    typealias Entry = ConsumptionTimelineEntry
    
    func createEntry(date: Date, consumed: Double) async throws -> Entry
    
    func delete(_ entry: Entry) async throws
    
    func fetchAll(at date: Date) async throws -> [Entry]
    func fetchAll() async throws -> [Entry]
}
