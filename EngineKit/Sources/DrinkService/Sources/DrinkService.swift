//
//  DrinkService.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation
import LoggingService
import DrinkServiceInterface
import DatabaseServiceInterface
import UnitServiceInterface

public final class DrinkService: DrinkServiceType {
    public typealias Engine = (
        HasLoggingService &
        HasContainerManagerService &
        HasUnitService
    )
    
    private let engine: Engine
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func addDrink(size: Double, container: Container) async throws -> Drink {
        let size: Int = Int(size)
        let newDrink = try await engine.containerManager.create(size: size)
        return Drink(from: newDrink, container: container)
    }
    
    public func editDrink(oldDrink: Drink, newDrink: Drink) async throws -> Drink {
        let oldSize = Int(oldDrink.size)
        let newSize = Int(newDrink.size)
        let updatedDrink = try await engine.containerManager.update(
            oldSize: oldSize,
            newSize: newSize
        )
        return Drink(from: updatedDrink, container: newDrink.container)
    }
    
    public func remove(_ drink: Drink) async throws {
        let size = Int(drink.size)
        try await engine.containerManager.delete(size: size)
    }
    
    public func getSavedDrinks() async throws -> [Drink] {
        let foundDrinks = try await engine.containerManager.fetchAll()
        var drinks: [Drink] = []
        for drink in foundDrinks {
            let index = foundDrinks.firstIndex(where: { $0.size == drink.size })
            let container: Container
            if index == 0 {
                container = .small
            } else if index == 1 {
                container = .medium
            } else {
                container = .large
            }
            drinks.append(.init(from: drink, container: container))
        }
        return drinks
    }
    
    public func resetToDefault() async -> [Drink] {
        let defaultDrinks: [Drink] = [
            .init(id: UUID().uuidString, size: 300, container: .small),
            .init(id: UUID().uuidString, size: 500, container: .medium),
            .init(id: UUID().uuidString, size: 750, container: .large)
            
        ]
        
        for drink in defaultDrinks {
            do {
                let size = Int(drink.size)
                _ = try await engine.containerManager.create(size: size)
            } catch {
                engine.logger.error("Couldn't store default drink \(drink)", 
                                    error: error)
                continue
            }
        }
        return defaultDrinks
    }
}

extension Drink {
    init(from drink: ContainerModel, container: Container) {
        self.init(
            id: drink.id,
            size: Double(drink.size),
            container: container
        )
    }
}
