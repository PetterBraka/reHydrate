//
//  TimelineServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/08/2023.
//

import Foundation

public protocol TimelineServiceType {
    func getTimeline(for date: Date) async -> [Timeline]
    func getTimelineCollection() async -> [TimelineCollection]
}
