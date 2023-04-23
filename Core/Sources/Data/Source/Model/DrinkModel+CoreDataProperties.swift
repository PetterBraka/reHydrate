//
//  DrinkModel+CoreDataProperties.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/04/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//
//

import Foundation
import CoreData


extension DrinkModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkModel> {
        return NSFetchRequest<DrinkModel>(entityName: "DrinkModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var size: Double
    @NSManaged public var day: DayModel?

}

extension DrinkModel : Identifiable {

}
