//
//  Date+extension.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Foundation

extension Date {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    func toString() -> String {
        Self.formatter.string(from: self)
    }
}
