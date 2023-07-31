//
//  Date+extension.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation

public let dbFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter
}()

extension Date {
    func toString() -> String {
        dbFormatter.string(from: self)
    }
}
