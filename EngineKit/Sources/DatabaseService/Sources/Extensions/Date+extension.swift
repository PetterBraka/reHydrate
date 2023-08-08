//
//  Date+extension.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation

public let dbDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter
}()

public let dbTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    formatter.timeZone = .gmt
    return formatter
}()
extension Date {
    func toDateString() -> String {
        dbDateFormatter.string(from: self)
    }
    
    func toTimeString() -> String {
        dbTimeFormatter.string(from: self)
    }
    
    }
}
