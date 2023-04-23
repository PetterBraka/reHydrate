//
//  DayModel+CoreDataProperties.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//
//

import Foundation
import CoreData


extension DayModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayModel> {
        return NSFetchRequest<DayModel>(entityName: "DayModel")
    }

    @NSManaged public var consumtion: Double
    @NSManaged public var date: Date?
    @NSManaged public var goal: Double
    @NSManaged public var id: UUID?
    @NSManaged public var drink: NSOrderedSet?

}

// MARK: Generated accessors for drink
extension DayModel {

    @objc(insertObject:inDrinkAtIndex:)
    @NSManaged public func insertIntoDrink(_ value: DrinkModel, at idx: Int)

    @objc(removeObjectFromDrinkAtIndex:)
    @NSManaged public func removeFromDrink(at idx: Int)

    @objc(insertDrink:atIndexes:)
    @NSManaged public func insertIntoDrink(_ values: [DrinkModel], at indexes: NSIndexSet)

    @objc(removeDrinkAtIndexes:)
    @NSManaged public func removeFromDrink(at indexes: NSIndexSet)

    @objc(replaceObjectInDrinkAtIndex:withObject:)
    @NSManaged public func replaceDrink(at idx: Int, with value: DrinkModel)

    @objc(replaceDrinkAtIndexes:withDrink:)
    @NSManaged public func replaceDrink(at indexes: NSIndexSet, with values: [DrinkModel])

    @objc(addDrinkObject:)
    @NSManaged public func addToDrink(_ value: DrinkModel)

    @objc(removeDrinkObject:)
    @NSManaged public func removeFromDrink(_ value: DrinkModel)

    @objc(addDrink:)
    @NSManaged public func addToDrink(_ values: NSOrderedSet)

    @objc(removeDrink:)
    @NSManaged public func removeFromDrink(_ values: NSOrderedSet)

}

extension DayModel : Identifiable {

}
