//
//  HealthKitPort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import HealthKit

final class HealthKitPort {
    let store = HKHealthStore()
    
    var isSupported: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    func shouldRequestAccess() async -> Bool{
        await withCheckedContinuation { [weak self] continuation in
            let healthData = HealthDataType.allCases.map {
                HKQuantityType($0.identifier.toHKQuantityTypeIdentifier())
            }
            self?.store.getRequestStatusForAuthorization(
                toShare: Set(healthData), read: Set(healthData)
            ) { status, error in
                if error != nil {
                    continuation.resume(returning: false)
                } else {
                    switch status {
                    case .shouldRequest:
                        continuation.resume(returning: true)
                    case .unknown, .unnecessary:
                        continuation.resume(returning: false)
                    @unknown default:
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }
    
    func canWrite(_ dataType: HealthDataType) -> Bool {
        let id = dataType.identifier.toHKQuantityTypeIdentifier()
        return store.authorizationStatus(for: HKQuantityType(id)) == .sharingAuthorized
    }
    
    func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws {
        let dataToRead = readAndWrite.map {
            HKQuantityType($0.identifier.toHKQuantityTypeIdentifier())
        }
        try await store.requestAuthorization(toShare: Set(dataToRead), read: Set(dataToRead))
    }
    
    func read(_ data: HealthDataType, for date: Date,
              completion: @escaping (Result<Double, Error>) -> Void) {
        let query = getQuery(.water, type: .sum(start: date, end: nil, completion: completion))
        store.execute(query)
    }
    
    func getQuery(_ data: HealthDataType, type: HealthQuery) -> HKQuery {
        switch type {
        case let .sum(startDate, endDate, completion):
            let query = HKStatisticsCollectionQuery(
                quantityType: .init(data.identifier.toHKQuantityTypeIdentifier()),
                quantitySamplePredicate: nil,
                options: .cumulativeSum,
                anchorDate: startDate,
                intervalComponents: DateComponents(day: 1))
            query.initialResultsHandler = { query, result, error in
                if let error {
                    completion(.failure(error))
                }
                guard let result else {
                    completion(.failure(HealthError.missingResult))
                    return
                }
                let calendar = Calendar.current
                let startDate = calendar.startOfDay(for: startDate)
                guard let endDate = endDate ?? calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) else {
                    completion(.failure(HealthError.missingEndDate))
                    return
                }
                result.enumerateStatistics(from: startDate, to: endDate) { statistics, pointer in
                    guard let quantity = statistics.sumQuantity() else {
                        completion(.failure(HealthError.noQuantity))
                        return
                    }
                    let value = quantity.doubleValue(for: .liter())
                    completion(.success(value))
                }
            }
            return query
        }
    }
    
    func export(quantity: Quantity, id: QuantityTypeIdentifier, _ date: Date) async throws {
        let quantity = quantity.toHKQuantity()
        let type = HKQuantityType(id.toHKQuantityTypeIdentifier())
        let sample = HKQuantitySample(type: type,
                                      quantity: quantity,
                                      start: date, end: date)
        try await store.save(sample)
    }
}

extension HealthKitPort {
    enum HealthDataType: CaseIterable {
        case water
        
        var identifier: QuantityTypeIdentifier {
            switch self {
            case .water:
                .dietaryWater
            }
        }
    }
    
    enum HealthQuery {
        case sum(start: Date, end: Date?, completion: ((Result<Double, Error>) -> Void))
    }
}

extension HealthKitPort {
    enum HealthError: Error {
        case missingResult
        case missingEndDate
        case noQuantity
    }
}

extension HealthKitPort {
    struct QuantitySample {
        let quantityTypeID: QuantityTypeIdentifier
        let quantity: Quantity
    }
    
    struct Quantity {
        let unit: HealthUnit
        let value: Double
    }
    
    enum QuantityTypeIdentifier {
        case bodyMass // kg, Discrete (Arithmetic)
        case height // m, Discrete (Arithmetic)
        
        // Nutrition
        case dietaryCaffeine // g, Cumulative
        case dietaryWater // mL, Cumulative
    }
    
    enum HealthUnit {
        case gram
        case meter
        case litre
    }
}

extension HealthKitPort.Quantity {
    init?(from quantity: HKQuantity) {
        if quantity.is(compatibleWith: .gram()) {
            self = .init(unit: .gram, value: quantity.doubleValue(for: .gram()))
        } else if quantity.is(compatibleWith: .meter()) {
            self = .init(unit: .meter, value: quantity.doubleValue(for: .meter()))
        } else if quantity.is(compatibleWith: .liter()) {
            self = .init(unit: .litre, value: quantity.doubleValue(for: .liter()))
        } else {
            return nil
        }
    }
    
    func toHKQuantity() -> HKQuantity {
        .init(unit: unit.toHKUnit(), doubleValue: value)
    }
}

extension HealthKitPort.QuantityTypeIdentifier {
    init?(from identifier: HKQuantityTypeIdentifier) {
        switch identifier {
        case .bodyMass:
            self = .bodyMass
        case .height:
            self = .height
        case .dietaryCaffeine:
            self = .dietaryCaffeine
        case .dietaryWater:
            self = .dietaryWater
        default:
            return nil
        }
    }
    
    func toHKQuantityTypeIdentifier() -> HKQuantityTypeIdentifier {
        switch self {
        case .bodyMass:
            .bodyMass
        case .height:
            .height
        case .dietaryCaffeine:
            .dietaryCaffeine
        case .dietaryWater:
            .dietaryWater
        }
    }
}

extension HealthKitPort.HealthUnit {
    init?(from unit: HKUnit) {
        switch unit {
        case .gram():
            self = .gram
        case .meter():
            self = .meter
        case .liter():
            self = .litre
        default:
            return nil
        }
    }

    func toHKUnit() -> HKUnit {
        switch self {
        case .gram:
            HKUnit.gram()
        case .meter:
            HKUnit.meter()
        case .litre:
            HKUnit.liter()
        }
    }
}
