//
//  DayRepository.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 16/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Combine
import CoreData
import Foundation

protocol DayRepositoryInterface {
    func create(day: Day) -> AnyPublisher<Bool, Error>
    func delete(day: Day) -> AnyPublisher<Bool, Error>
    func getDay(for date: Date) -> AnyPublisher<Day?, Error>
    func getDays() -> AnyPublisher<[Day], Error>
    func update(goal: Double, for day: Day) -> AnyPublisher<Bool, Error>
    func update(consumption: Double, for day: Day) -> AnyPublisher<Bool, Error>
}

final class DayRepository: DayRepositoryInterface {
    private let repo: CoreDataRepository<DayModel>
    private let repoPredicate = NSPredicate(format: "TRUEPREDICATE")
    private let repoSortDescriptors = [NSSortDescriptor(keyPath: \DayModel.date, ascending: false)]
    
    init(context: NSManagedObjectContext) {
        self.repo = CoreDataRepository<DayModel>(context: context)
    }
    
    func create(day: Day) -> AnyPublisher<Bool, Error> {
        repo.create()
            .map { dayModel -> Bool in
                dayModel.updateCoreDataModel(day)
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func delete(day: Day) -> AnyPublisher<Bool, Error> {
        repo.get(id: day.id.uuidString,
                 predicate: repoPredicate,
                 sortDescriptors: repoSortDescriptors)
            .map { day -> Bool in
                if let day = day {
                    _ = self.repo.delete(day)
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getDay(for date: Date) -> AnyPublisher<Day?, Error> {
        repo.get(date: date,
                 predicate: repoPredicate,
                 sortDescriptors: repoSortDescriptors)
            .map { day -> Day? in
                let day = day.map { day -> Day in
                    return day.toDomainModel()
                }
                return day
            }
            .eraseToAnyPublisher()
    }
    
    func getDays() -> AnyPublisher<[Day], Error> {
        repo.getAll(predicate: repoPredicate, sortDescriptors: repoSortDescriptors  )
            .map { daysModel -> [Day] in
                let days = daysModel.map { daysModel -> Day in
                    return daysModel.toDomainModel()
                }
                return days
            }
            .eraseToAnyPublisher()
    }
    
    func update(goal: Double, for day: Day) -> AnyPublisher<Bool, Error> {
        repo.get(id: day.id.uuidString,
                 predicate: repoPredicate,
                 sortDescriptors: repoSortDescriptors)
            .map { day -> Bool in
                if let day = day {
                    day.goal = goal
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func update(consumption: Double, for day: Day) -> AnyPublisher<Bool, Error> {
        repo.get(id: day.id.uuidString,
                 predicate: repoPredicate,
                 sortDescriptors: repoSortDescriptors)
            .map { day -> Bool in
                if let day = day {
                    day.consumtion = consumption
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
}
