//
//  Drink.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import Foundation

public struct Drink: DrinkProtocol {
    public let id: UUID

    public let type: DrinkType
    public var size: Double

    public var fill: Double {
        size / Double(type.max)
    }

    public init(id: UUID = UUID(),
                type: DrinkType,
                size: Double) {
        self.id = id
        self.type = type
        self.size = size
    }
}
