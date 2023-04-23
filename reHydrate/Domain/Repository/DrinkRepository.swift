//
//  DrinkRepository.swift
//  reHydrate
//
//  Created by Petter Vang Brakalsvalet on 29/01/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation

protocol DrinkRepositoryProtocol {
    func fetchDrinks(for date: Date) async throws -> [Drink]
    func remove(drink: Drink) async throws
    func addDrink(_ size: Double, _ type: Drink.Option) async throws -> Drink
    func update(sizeOf size: Double, drink: Drink) async throws -> Drink
}

@available(iOS, introduced: 16.4)
final class DrinkRepository: DrinkRepositoryProtocol {
    let settingsRepo: SettingsRepository = MainAssembler.resolve()
    let service: DrinkService

    init(service: DrinkService) {
        self.service = service
    }

    @available(*, deprecated,
               message: "This is only designed to migrate from version 5.2.2 to 6.0.0")
    func migrate() async throws -> [Drink] {
        let smallDrink = await settingsRepo.smallDrink
        let mediumDrink = await settingsRepo.mediumDrink
        let largeDrink = await settingsRepo.largeDrink
        let small = try await addDrink(smallDrink, .small)
        let medium = try await addDrink(mediumDrink, .medium)
        let large = try await addDrink(largeDrink, .large)
        return [small, medium, large]
    }

    func fetchDrinks(for _: Date) async throws -> [Drink] {
        try await service.getAll().map { $0.toDomainModel() }
    }

    func remove(drink: Drink) async throws {
        try await service.delete(drink)
    }

    func addDrink(_ size: Double, _ type: Drink.Option) async throws -> Drink {
        let drinkModel = try await service.create(Drink(type: type, size: size))
        return drinkModel.toDomainModel()
    }

    func update(sizeOf size: Double, drink: Drink) async throws -> Drink {
        let drinkModels = try await service.getAll()
        guard let drinkModel = drinkModels.first(where: { $0.id == drink.id })
        else { throw CoreDataError.elementNotFound }
        drinkModel.size = size
        try await service.save()
        return drinkModel.toDomainModel()
    }
}
