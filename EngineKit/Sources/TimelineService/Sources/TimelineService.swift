//
//  TimelineService.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/08/2023.
//

import Foundation
import TimelineServiceInterface
import DatabaseServiceInterface
import DatabaseService

public final class TimelineService: TimelineServiceType {
    public typealias Engine = (
        HasConsumptionManagerService
    )
    
    private let engine: Engine
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func getTimeline(for date: Date) async -> [Timeline] {
        do {
            let result = try await engine.consumptionManager.fetchAll(at: date)
            return result.map { Timeline(from: $0) }
        } catch {
            return []
        }
    }
    
    public func getTimelineCollection() async -> [TimelineCollection] {
        do {
            let result = try await engine.consumptionManager.fetchAll()
            
            return .init(from: result)
        } catch {
            return []
        }
    }
}
 
extension Timeline {
    init(from consumption: Consumption) {
        self.init(time: consumption.time, consumed: consumption.consumed)
    }
}

extension TimelineCollection {
    init?(dateString: String, timeline: [Timeline]) {
        guard let date = dbDateFormatter.date(from: dateString) else { return nil }
        
        self.init(
            date: date,
            timeline: timeline
        )
    }
}

extension Array where Element == TimelineCollection {
    init(from consumption: [Consumption]) {
        self.init(
            Dictionary(grouping: consumption, by: { $0.date })
                .compactMap { (dateString, consumptions) -> TimelineCollection? in
                    TimelineCollection(
                        dateString: dateString,
                        timeline: consumptions.map { Timeline(from: $0) }
                    )
                }
        )
    }
}
