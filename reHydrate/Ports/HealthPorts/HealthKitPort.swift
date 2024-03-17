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
        let healthData = healthDataType.map { HKQuantityType(from: $0) }
        let status = try? await store.statusForAuthorizationRequest(
            toShare: Set(healthData), read: Set(healthData)
        )
        return switch status {
        case .shouldRequest, .unknown, .none:
            true
        case .unnecessary:
            false
        @unknown default:
            true
        }
    }
    
    public func canWrite(_ dataType: HealthDataType) -> Bool {
        store.authorizationStatus(for: HKQuantityType(from: dataType)) == .sharingAuthorized
    }
    
    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws {
        let dataToRead = readAndWrite.map {
            HKQuantityType(from: $0)
        }
        try await store.requestAuthorization(toShare: Set(dataToRead), read: Set(dataToRead))
    }
    
    public func readSum(_ data: HealthDataType, start: Date, end: Date, 
                        intervalComponents: DateComponents) async throws -> Double {
        let predicate = HKSamplePredicate.quantitySample(
            type: HKQuantityType(from: data),
            predicate: HKQuery.predicateForSamples(withStart: start, end: end)
        )
        let query = HKStatisticsQueryDescriptor(
            predicate: predicate,
            options: .cumulativeSum
        )
        let result = try await query.result(for: store)?
            .sumQuantity()?
            .doubleValue(for: data.unit.toHK())
        return result ?? 0
    }
    
    public func readSamples(_ data: HealthDataType, 
                            start: Date, end: Date) async throws -> [Double] {
        let predicate = HKSamplePredicate.quantitySample(
            type: HKQuantityType(from: data),
            predicate: HKQuery.predicateForSamples(withStart: start, end: end)
        )
        let query = HKSampleQueryDescriptor(
            predicates: [predicate],
            sortDescriptors: [.init(\.endDate)]
        )
        
        return try await query.result(for: store)
            .map { $0.quantity.doubleValue(for: data.unit.toHK()) }
    }
    
    public func export(quantity: Quantity,
                id: QuantityTypeIdentifier,
                date: Date) async throws {
        let sample = HKQuantitySample(
            type: HKQuantityType(from: id),
            quantity: .init(from: quantity),
            start: date, 
            end: date
        )
        try await store.save(sample)
    }
    
    public func enableBackgroundDelivery(healthData: HealthDataType,
                                  frequency: HealthFrequency) async throws {
        try await store.enableBackgroundDelivery(
            for: HKQuantityType(from: healthData),
            frequency: .init(from: frequency)
        )
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
}

extension HKQuantity {
    convenience init(from quantity: Quantity) {
        self.init(unit: quantity.unit.toHK(), doubleValue: quantity.value)
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
}

extension HKQuantityType {
    convenience init(from dataType: HealthDataType) {
        self.init(from: dataType.identifier)
    }
    
    convenience init(from identifier: QuantityTypeIdentifier) {
        switch identifier {
        case .bodyMass:
            self.init(.bodyMass)
        case .height:
            self.init(.height)
        case .dietaryCaffeine:
            self.init(.dietaryCaffeine)
        case .dietaryWater:
            self.init(.dietaryWater)
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

extension HKUpdateFrequency {
    public init(from frequency: HealthFrequency) {
        switch frequency {
        case .daily:
            self = .daily
        case .hourly:
            self = .hourly
        case .immediately:
            self = .immediate
        }
    }
}
