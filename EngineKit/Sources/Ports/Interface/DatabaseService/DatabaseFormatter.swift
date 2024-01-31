//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/01/2024.
//

import Foundation

public enum DatabaseFormatter {
    public static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    public static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = .gmt
        return formatter
    }()
    
    public static let dateTime: DateFormatter = {
        let formatter = DateFormatter()
        guard let dateFormat = date.dateFormat,
              let timeFormate = time.dateFormat
        else {
            fatalError("Date or time formatter hasn't been set correctly!")
        }
        formatter.dateFormat = "\(dateFormat) \(timeFormate)"
        formatter.timeZone = .gmt
        return formatter
    }()
}
