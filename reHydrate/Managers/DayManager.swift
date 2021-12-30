//
//  DayManager.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 21/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import CoreData
import Combine

final class DayManager {
    private let context: NSManagedObjectContext
    let dayRepository: DayRepository

    init(context: NSManagedObjectContext) {
        self.context = context
        self.dayRepository = DayRepository(context: context)
    }

    func saveChanges() -> AnyPublisher<Bool, Error> {
        Future { prommise in
            do {
                try self.context.save()
                return prommise(.success(true))
            } catch {
                self.context.rollback()
                return prommise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
