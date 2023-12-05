//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 05/12/2023.
//

import Foundation

struct ViewModel {
    let dates: [Date]
}


extension ViewModel {
    struct CalendarDate {
        let date: Date
        let isWeekday: Bool
        let isThisMonth: Bool
    }
}
