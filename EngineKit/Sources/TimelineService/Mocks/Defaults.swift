//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/02/2024.
//

import TimelineServiceInterface

extension Array where Element == Timeline {
    static let `default` = [Timeline]()
}

extension Array where Element == TimelineCollection {
    static let `default` = [TimelineCollection]()
}
