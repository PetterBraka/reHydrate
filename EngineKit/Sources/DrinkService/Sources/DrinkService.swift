//
//  DrinkService.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import Foundation
import LoggingService
import PortsInterface
import DrinkServiceInterface
import UnitServiceInterface
import DBKitInterface
import NotificationCenterServiceInterface

public final class DrinkService: DrinkServiceType {
    public typealias Engine = (
        HasLoggerService &
        HasDrinkManagerService &
        HasUnitService &
        HasNotificationCenter
    )
    
    private let engine: Engine
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func add(size: Double, container: Container) async throws -> Drink {
        let newDrink = try engine.drinkManager.createNewDrink(
            size: size, container: container.rawValue
        )
        guard let newDrink = Drink(from: newDrink) else {
            let error = DrinkDBError.creatingDrink
            engine.logger.log(
                category: .drinkService,
                message: "Couldn't map new drink \(newDrink)",
                error: error,
                level: .error
            )
            throw error
        }
        engine.notificationCenter.post(name: .drinkDidChange)
        return newDrink
    }
    
    public func edit(size: Double, of container: Container) async throws -> Drink {
        let updatedDrink = try await engine.drinkManager.edit(
            size: size,
            of: container.rawValue
        )
        guard let updatedDrink = Drink(from: updatedDrink) else {
            let error = DrinkDBError.notFound
            engine.logger.log(
                category: .drinkService,
                message: "Couldn't map edited drink \(updatedDrink)",
                error: error,
                level: .error
            )
            throw error
        }
        engine.notificationCenter.post(name: .drinkDidChange)
        return updatedDrink
    }
    
    public func remove(container: Container) async throws {
        try await engine.drinkManager.deleteDrink(container: container.rawValue)
        engine.notificationCenter.post(name: .drinkDidChange)
    }
    
    public func getSaved() async throws -> [Drink] {
        let drinks = try await engine.drinkManager.fetchAll()
        return drinks.compactMap { .init(from: $0) }
    }
    
    public func resetToDefault() async -> [Drink] {
        do {
            try await engine.drinkManager.deleteAll()
        } catch {
            engine.logger.log(
                category: .drinkService,
                message: "Couldn't reset drinks",
                error: error,
                level: .error
            )
        }
        let defaultDrinks: [Drink] = [
            .init(id: UUID().uuidString, size: 300, container: .small),
            .init(id: UUID().uuidString, size: 500, container: .medium),
            .init(id: UUID().uuidString, size: 750, container: .large)
        ]
        for drink in defaultDrinks {
            do {
                _ = try engine.drinkManager.createNewDrink(
                    size: drink.size, container: drink.container.rawValue
                )
            } catch {
                engine.logger.log(
                    category: .drinkService,
                    message: "Couldn't store default drink \(drink)",
                    error: error,
                    level: .error
                )
                continue
            }
        }
        engine.notificationCenter.post(name: .drinkDidChange)
        return defaultDrinks
    }
}

extension Drink {
    init?(from drink: DrinkModel) {
        guard let container = Container(rawValue: drink.container) else {
            return nil
        }
        self.init(
            id: drink.id,
            size: drink.size,
            container: container
        )
    }
}
