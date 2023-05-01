//
//  Drink.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import CoreInterfaceKit
import CoreKit
import SwiftUI

public struct Drink: DrinkProtocol {
    public let id: UUID

    public var type: DrinkType
    public var size: Double

    public var fill: Double {
        size / Double(type.max)
    }

    private let settingsRepo: SettingsRepository = MainAssembler.resolve()

    init(id: UUID = UUID(),
         type: DrinkType,
         size: Double) {
        self.id = id
        self.type = type
        self.size = size
    }

    func toLocal(withUnit symbol: Bool = true) -> String {
        UnitConversionHelper.getLocal(self, withUnit: symbol,
                                      inMetric: settingsRepo.isMetric)
    }

    func getImage(with fill: Double? = nil) -> Image {
        let fill = fill ?? self.fill
        switch type {
        case .small: return .getGlass(with: fill)
        case .medium: return .getBottle(with: fill)
        case .large: return .getReusableBottle(with: fill)
        }
    }
}

extension Drink: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(size)
        hasher.combine(fill)
    }

    public static func == (lhs: Drink, rhs: Drink) -> Bool {
        lhs.id == rhs.id &&
            lhs.type == rhs.type &&
            lhs.size == rhs.size &&
            lhs.fill == rhs.fill
    }
}
