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
    func getWater(for date: Date) -> AnyPublisher<Double, Error>
    func export(drink: Drink, _ date: Date) -> AnyPublisher<Void, Error>
}

// Possible errors that can occur
enum HealthError: Error {
    case notAuthorized
    case cantSaveEmpty
}

enum HealthType: CaseIterable {
    case water

    fileprivate func toObjectType() -> HKObjectType {
        switch self {
        case .water:
            return .quantityType(forIdentifier: .dietaryWater)!
        }
    }

    fileprivate func toSampleType() -> HKQuantityType {
        switch self {
        case .water:
            return .quantityType(forIdentifier: .dietaryWater)!
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

    func getWater(for date: Date) -> AnyPublisher<Double, Error> {
        Future { [unowned self] promise in
            let quantityType = HealthType.water.toSampleType()
            guard healthStore.authorizationStatus(for: quantityType) == .sharingAuthorized else {
                promise(.failure(HealthError.notAuthorized))
                return
            }

            let calendar = Calendar.current
            let components = DateComponents(calendar: calendar,
                                            timeZone: calendar.timeZone,
                                            hour: 0, minute: 0, second: 0)

            guard let anchorDate = calendar.nextDate(after: Date(),
                                                     matching: components,
                                                     matchingPolicy: .nextTime,
                                                     repeatedTimePolicy: .first,
                                                     direction: .backward) else {
                fatalError("*** unable to find the previous Monday. ***")
            }

            // Create the query.
            let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                    quantitySamplePredicate: nil,
                                                    options: .cumulativeSum,
                                                    anchorDate: anchorDate,
                                                    intervalComponents: DateComponents(day: 1))
            query.initialResultsHandler = { _, results, error in
                // Handle errors here.
                if let error = error as? HKError { promise(.failure(error)) }

                guard let results = results else { return }
                let startDate = calendar.startOfDay(for: date)

                guard let tomorrow = calendar.date(byAdding: DateComponents(day: 1), to: date) else {
                    fatalError("*** Unable to calculate the start date ***")
                }
                results.enumerateStatistics(from: startDate, to: tomorrow) { (statistics, _) in
                    if let quantity = statistics.sumQuantity() {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        let startDate = formatter.string(from: statistics.startDate)
                        let value = quantity.doubleValue(for: .liter())

                        // Extract each week's data.
                        print("start date: \(startDate) - \(value)")
                        promise(.success(value))
                    }
                }
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
        let quantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: drink.size)
        let sample = HKQuantitySample(type: HealthType.water.toSampleType(),
                                      quantity: quantity,
                                      start: date, end: date)
        return Future { promise in
            if drink.size != 0 {
                HKHealthStore().save(sample) { (_, error) in
                    guard let error = error else {
                        print("Successfully saved water consumtion")
                        promise(.success(()))
                        return
                    }
                    print("Error Saving water consumtion: \(error.localizedDescription)")
                    promise(.failure(error))
                }
            } else {
                promise(.failure(HealthError.cantSaveEmpty))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
