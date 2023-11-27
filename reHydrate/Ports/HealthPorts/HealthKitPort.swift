//
//  HealthKitPort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import PortsInterface
import HealthKit

public final class HealthKitPort: HealthInterface {
    private let store = HKHealthStore()
    
    public var isSupported: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    public func shouldRequestAccess(for healthDataType: [HealthDataType]) async -> Bool {
        await withCheckedContinuation { [weak self] continuation in
            let healthData = healthDataType.map {
                HKQuantityType($0.identifier.toHK())
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
    
    public func canWrite(_ dataType: HealthDataType) -> Bool {
        let id = dataType.identifier.toHK()
        return store.authorizationStatus(for: HKQuantityType(id)) == .sharingAuthorized
    }
    
    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws {
        let dataToRead = readAndWrite.map {
            HKQuantityType($0.identifier.toHK())
        }
        try await store.requestAuthorization(toShare: Set(dataToRead), read: Set(dataToRead))
    }
    
    public func read(_ data: HealthDataType, queryType: HealthQuery) {
        let query = createQuery(data, queryType: queryType)
        store.execute(query)
    }
    
    public func export(quantity: Quantity,
                id: QuantityTypeIdentifier,
                date: Date) async throws {
        let quantity = quantity.toHKQuantity()
        let type = HKQuantityType(id.toHK())
        let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
        try await store.save(sample)
    }
    
    public func enableBackgroundDelivery(healthData: HealthDataType,
                                  frequency: HealthFrequency) async throws {
        let object = HKQuantityType(healthData.identifier.toHK())
        try await store.enableBackgroundDelivery(for: object, frequency: frequency.toHK())
    }
}

private extension HealthKitPort {
    func createQuery(_ healthData: HealthDataType, queryType: HealthQuery) -> HKQuery {
        switch queryType {
        case let .sum(startDate, endDate, intervalComponents, completion):
            let query = HKStatisticsCollectionQuery(
                quantityType: .init(healthData.identifier.toHK()),
                quantitySamplePredicate: nil,
                options: .cumulativeSum,
                anchorDate: startDate,
                intervalComponents: intervalComponents)
            query.initialResultsHandler = { query, result, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                guard let result else {
                    completion(.failure(HealthError.missingResult))
                    return
                }
                result.enumerateStatistics(from: startDate, to: endDate) { statistics, pointer in
                    guard let quantity = statistics.sumQuantity() else {
                        completion(.failure(HealthError.noQuantity))
                        return
                    }
                    let value = quantity.doubleValue(for: healthData.unit.toHK())
                    completion(.success(value))
                }
            }
            return query
        case let .sample(start, end, completion):
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
            let query = HKSampleQuery(
                sampleType: HKQuantityType(healthData.identifier.toHK()),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [.init(key: HKSampleSortIdentifierStartDate, ascending: false)]) { sampleQuery, samples, error in
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    guard let quantitySamples = samples as? [HKQuantitySample] else {
                        completion(.failure(HealthError.missingResult))
                        return
                    }
                    let values = quantitySamples.map {
                        $0.quantity.doubleValue(for: healthData.unit.toHK())
                    }
                    completion(.success(values))
                }
            return query
        }
    }
}

extension Quantity {
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
        .init(unit: unit.toHK(), doubleValue: value)
    }
}

extension QuantityTypeIdentifier {
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
    
    func toHK() -> HKQuantityTypeIdentifier {
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

extension HealthUnit {
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

    func toHK() -> HKUnit {
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

extension HealthFrequency {
    func toHK() -> HKUpdateFrequency {
        switch self {
        case .daily:
            .daily
        case .hourly:
            .hourly
        case .immediately:
            .immediate
        }
    }
}
