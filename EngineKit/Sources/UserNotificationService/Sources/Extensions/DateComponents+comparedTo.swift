//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 01/10/2023.
//

import Foundation

public extension DateComponents {
    func comparedTo(_ dateComponents: DateComponents,_ range: Int) -> Bool {
        guard let hour, let minute,
              let dateComponentsHour = dateComponents.hour,
              let dateComponentsMinute = dateComponents.minute
        else {
            return false
        }
        
        let totalMinutes = hour * 60 + minute
        let totalDateComponentsMinutes = dateComponentsHour * 60 + dateComponentsMinute
        let minuteDifference = abs(totalMinutes - totalDateComponentsMinutes)
        return minuteDifference <= range
    }
}
