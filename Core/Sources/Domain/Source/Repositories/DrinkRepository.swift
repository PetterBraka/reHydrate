//
//  DrinkRepository.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Data
import DomainInterface

@available(iOS, introduced: 16.4)
final class DrinkRepository: DrinkRepositoryProtocol {
    let settingsRepo: SettingsRepository
    let service: DrinkService

    init(settingsRepo: SettingsRepository,
         service: DrinkService) {
        self.settingsRepo = settingsRepo
        self.service = service
    }

    @available(*, deprecated,
               message: "This is only designed to migrate from version 5.2.2 to 6.0.0")
    func migrate() async throws -> [Drink] {
        let smallDrink = await settingsRepo.smallDrink
        let mediumDrink = await settingsRepo.mediumDrink
        let largeDrink = await settingsRepo.largeDrink
        let small = try await addDrink(smallDrink)
        let medium = try await addDrink(mediumDrink)
        let large = try await addDrink(largeDrink)
        return [small, medium, large]
    }

    func fetchDrinks(for _: Date) async throws -> [Drink] {
        try await service.getAll().map { try $0.toDomainModel() }
    }

    func remove(drink: Drink) async throws {
        try await service.delete(itemWithId: drink.id)
    }

    func addDrink(_ size: Double) async throws -> Drink {
        let newDrink = try await service.create(id: UUID(), ofSize: size)
        return try newDrink.toDomainModel()
    }

    func update(sizeOf size: Double, drink: Drink) async throws -> Drink {
        let drink = try await service.getElement(with: drink.id)
        drink.size = size
        try await service.save()
        return try drink.toDomainModel()
    }
}
