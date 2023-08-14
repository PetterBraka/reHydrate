//
//  TimelineCollection.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/08/2023.
//

import Foundation

public struct TimelineCollection {
    public let date: Date
    public var timeline: [Timeline]
    
    public init(date: Date, timeline: [Timeline]) {
        self.date = date
        self.timeline = timeline
    }
}
