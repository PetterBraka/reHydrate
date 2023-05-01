//
//  HealthManagerProtocol.swift
//  
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//

import Foundation
import Combine

public protocol HealthManagerProtocol {
    var needsAccess: Bool { get }
    func requestAccess() async throws
    func getWater(for date: Date) -> AnyPublisher<Double, Error>
    func export(drinkOfSize drink: Double, _ date: Date) -> AnyPublisher<Void, Error>
}
