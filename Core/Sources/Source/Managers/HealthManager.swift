//
//  HealthManager.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 04/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreInterfaceKit
import Foundation
import HealthKit
import os
import UserNotifications

public class HealthManager: HealthManagerProtocol {
    private static let logger = Logger(subsystem: "health.manager", category: "HealthKit")
    private let healthStore = HKHealthStore()

    private let readTypes: Set<HKObjectType> = Set(HealthType.allCases.map { $0.toObjectType() })
    private let writeTypes: Set<HKSampleType> = Set(HealthType.allCases.map { $0.toSampleType() })

    public var needsAccess: Bool {
        HealthType.allCases.contains { current in
            healthStore.authorizationStatus(for: current.toObjectType()) == .notDetermined
        }
    }

    public init() {}

    public func requestAccess() async throws {
        try await healthStore.requestAuthorization(toShare: writeTypes,
                                                   read: readTypes)
    }

    /// Will get the water consumption for the date passed in
    public func getWater(for date: Date,
                         completion: @escaping (Result<Double, Error>) -> Void) {
        let quantityType = HealthType.water.toSampleType()
        guard healthStore.authorizationStatus(for: quantityType) == .sharingAuthorized else {
            completion(.failure(HealthError.notAuthorized))
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
                                                 direction: .backward)
        else {
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
            if let error = error as? HKError { completion(.failure(error)) }

            guard let results = results else { return }
            let startDate = calendar.startOfDay(for: date)

            guard let tomorrow = calendar.date(byAdding: DateComponents(day: 1), to: date) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            results.enumerateStatistics(from: startDate, to: tomorrow) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    let startDate = formatter.string(from: statistics.startDate)
                    let value = quantity.doubleValue(for: .liter())

                    // Extract each week's data.
                    print("start date: \(startDate) - \(value)")
                    completion(.success(value))
                } else {
                    completion(.failure(HealthError.noDataFound))
                }
            }
        }
        healthStore.execute(query)
    }

    /**
     Will export a drink to the health app

     - parameter waterAmount: - The amount of water consumed.
     - parameter date: -The date of consumption.
     */
    public func export(drinkOfSize drink: Double, _ date: Date,
                       completion: @escaping (Result<Void, Error>) -> Void) {
        let quantity = HKQuantity(unit: HKUnit.literUnit(with: .milli),
                                  doubleValue: drink)
        let sample = HKQuantitySample(type: HealthType.water.toSampleType(),
                                      quantity: quantity,
                                      start: date, end: date)
        guard drink != 0 else {
            completion(.failure(HealthError.cantSaveEmpty))
            return
        }
        HKHealthStore().save(sample) { _, error in
            if let error {
                print("Error Saving water consumtion: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
