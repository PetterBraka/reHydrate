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
    func getWater(for date: Date,
                  completion: @escaping (Result<Double, Error>) -> Void)
    func export(drinkOfSize drink: Double, _ date: Date,
                completion: @escaping (Result<Void, Error>) -> Void)
}
