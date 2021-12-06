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
            guard let type: HKSampleType = writeTypes.first else {
                promise(.failure(HealthError.notAuthorized))
                return
            }
            
            guard healthStore.authorizationStatus(for: type) == .sharingAuthorized else {
                promise(.failure(HealthError.notAuthorized))
                return
            }
            
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.calendar, .year, .month, .day], from: Date())
            
            let startDate = calendar.date(from: components)!
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
            let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            
            let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            
            let HKcalendar = Calendar.current
            // Create a 1-week interval.
            let interval = DateComponents(day: 7)
            // Set the anchor for 3 a.m. on Monday.
            let HKcomponents = DateComponents(calendar: HKcalendar,
                                            timeZone: HKcalendar.timeZone,
                                            hour: 3,
                                            minute: 0,
                                            second: 0)
            
            guard let anchorDate = HKcalendar.nextDate(after: Date(),
                                                     matching: HKcomponents,
                                                     matchingPolicy: .nextTime,
                                                     repeatedTimePolicy: .first,
                                                     direction: .backward) else {
                fatalError("*** unable to find the previous Monday. ***")
            }
            guard let quantityType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                fatalError("*** Unable to create a water type ***")
            }
            
            // Create the query.
            let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                    quantitySamplePredicate: nil,
                                                    options: .cumulativeSum,
                                                    anchorDate: anchorDate,
                                                    intervalComponents: interval)
            query.initialResultsHandler = {
                query, results, error in
                
                // Handle errors here.
                if let error = error as? HKError {
                    switch (error.code) {
                    case .errorDatabaseInaccessible:
                        // HealthKit couldn't access the database because the device is locked.
                        return
                    default:
                        // Handle other HealthKit errors here.
                        return
                    }
                }
                
                guard let statsCollection = results else {
                    // You should only hit this case if you have an unhandled error. Check for bugs
                    // in your code that creates the query, or explicitly handle the error.
                    assertionFailure("")
                    return
                }
                let endDate = Date()
                let threeMonthsAgo = DateComponents(month: -3)
                
                guard let startDate = HKcalendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                    fatalError("*** Unable to calculate the start date ***")
                }
                
                // Plot the weekly step counts over the past 3 months.
                // Enumerate over all the statistics objects between the start and end dates.
                statsCollection.enumerateStatistics(from: startDate, to: endDate)
                { (statistics, stop) in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let value = quantity.doubleValue(for: .liter())
                        
                        // Extract each week's data.
                        print("start date: \(date) end date: \(statistics.endDate) - \(value)")
                    }
                }
            }
            
//            let query = HKSampleQuery(sampleType: type,
//                                      predicate: today,
//                                      limit: .max,
//                                      sortDescriptors: sortDescriptors) { _, samplesOrNil, errorOrNil in
//                if let error = errorOrNil {
//                    promise(.failure(error))
//                }
//                guard let samples = samplesOrNil as? [HKQuantity] else {
//                    promise(.success([]))
//                    return
//                }
//                promise(.success(samples))
//            }
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
