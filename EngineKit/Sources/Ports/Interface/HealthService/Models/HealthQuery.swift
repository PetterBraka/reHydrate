//
//  HealthQuery.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/11/2023.
//

import Foundation

public enum HealthQuery {
    case sum(start: Date, end: Date, intervalComponents: DateComponents, completion: ((Result<Double, HealthError>) -> Void))
    case sample(start: Date, end: Date, completion: ((Result<[Double], HealthError>) -> Void))
}
