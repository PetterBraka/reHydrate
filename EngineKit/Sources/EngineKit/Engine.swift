//
//  Engine.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import DayServiceInterface
import DayService

public final class Engine {
    public init() {}
    
    public lazy var consumptionService: ConsumptionServiceType = ConsumptionService()
}

extension Engine: HasService {}
