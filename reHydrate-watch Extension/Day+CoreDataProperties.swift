//
//  Day+CoreDataProperties.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2020.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date
    @NSManaged public var goal: Double
    @NSManaged public var consumed: Double

}
