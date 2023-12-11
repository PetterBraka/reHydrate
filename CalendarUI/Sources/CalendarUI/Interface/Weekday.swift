//
//  Weekday.swift
//
//
//  Created by Petter vang Brakalsvålet on 11/12/2023.
//

public enum Weekday: CaseIterable {
    public static var allCases: [Weekday] = [
        .sunday, .monday, .tuesday,
        .wednesday, .thursday, .friday,
        .saturday
    ]
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var number: Int {
        switch self {
        case .sunday: 1
        case .monday: 2
        case .tuesday: 3
        case .wednesday: 4
        case .thursday: 5
        case .friday: 6
        case .saturday: 7
        }
    }
    
    var offset: Int {
        switch self {
        case .sunday: 7
        case .monday: 6
        case .tuesday: 5
        case .wednesday: 4
        case .thursday: 3
        case .friday: 2
        case .saturday: 1
        }
    }
}
