//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/02/2024.
//

import TimelineServiceInterface

extension Array where Element == Timeline {
    nonisolated(unsafe) static let `default` = [Timeline]()
}

extension Array where Element == TimelineCollection {
    nonisolated(unsafe) static let `default` = [TimelineCollection]()
}
