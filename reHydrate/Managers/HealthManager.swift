//
//  HealthManager.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 04/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import Foundation
import HealthKit
import UserNotifications

protocol HealthManagerProtocol {
    func needsAccessRequest() -> Bool
    func requestAccess() -> AnyPublisher<Void, Error>
    func getWater() -> AnyPublisher<[HKQuantity], Error>
}

// Possible errors that can occur
enum HealthError: Error {
    case cantSaveEmpty
}

enum HealthType: CaseIterable {
    case water

    fileprivate func toObjectType() -> HKObjectType {
        switch self {
        case .water:
            return .quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        }
    }

    fileprivate func toSampleType() -> HKQuantityType {
        switch self {
        case .water:
            return .quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        }
    }
}

class HealthManager: HealthManagerProtocol {
    static let shared = HealthManager()
    
    private let healthStore = HKHealthStore()

    private let readTypes: Set<HKObjectType> = Set(HealthType.allCases.map { $0.toObjectType() })
    private let writeTypes: Set<HKSampleType> = Set(HealthType.allCases.map { $0.toSampleType() })

    func needsAccessRequest() -> Bool {
        HealthType.allCases.contains { current in
            healthStore.authorizationStatus(for: current.toObjectType()) == .notDetermined
        }
    }

    func requestAccess() -> AnyPublisher<Void, Error> {
        Future { [unowned self] promise in
            self.healthStore.requestAuthorization(toShare: self.writeTypes, read: self.readTypes) { _, error in
                guard let error = error else {
                    promise(.success(()))
                    return
                }
                promise(.failure(error))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }

    func getWater() -> AnyPublisher<[HKQuantity], Error> {
        Future { [unowned self] promise in
            let type = HKSampleType.workoutType()

            let calendar = NSCalendar.current
            let now = Date()
            let components = calendar.dateComponents([.calendar, .year, .month, .day], from: now)

            let startDate = calendar.date(from: components)!
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

            let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

            let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            let query = HKSampleQuery(sampleType: type,
                                      predicate: today,
                                      limit: 3,
                                      sortDescriptors: sortDescriptors) { _, samplesOrNil, errorOrNil in
                if let error = errorOrNil {
                    promise(.failure(error))
                }
                guard let samples = samplesOrNil as? [HKQuantity] else {
                    promise(.success([]))
                    return
                }
                promise(.success(samples))
            }
            healthStore.execute(query)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    /**
     Will export a drink to the health app
     
     - parameter waterAmount: - The amount of water the drink contains.
     - parameter date: -The date the drink was consumed.
     - warning: Will print an error if it wasn't able to export the drink, or if it was successfull.
     
     # Example #
     ```
     
     exportDrinkToHealth(200, Date.init())
     ```
     */
    func export(drink: Drink, _ date: Date) -> AnyPublisher<Void, Error> {
        let quantity = HKQuantity(unit: HKUnit.liter(), doubleValue: drink.size)
        let sample = HKQuantitySample(type: HealthType.water.toSampleType(),
                                      quantity: quantity,
                                      start: date, end: date)
        return Future { promise in
            if drink.size > 0 {
                HKHealthStore().save(sample) { (_, error) in
                    guard let error = error else {
                        print("Successfully saved water consumtion")
                        promise(.success(()))
                        return
                    }
                    print("Error Saving water consumtion: \(error.localizedDescription)")
                    promise(.failure(error))
                }
            }
            promise(.failure(HealthError.cantSaveEmpty))
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
