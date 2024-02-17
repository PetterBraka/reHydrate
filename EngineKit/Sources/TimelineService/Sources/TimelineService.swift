//
//  TimelineService.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/08/2023.
//

import Foundation
import TimelineServiceInterface
import PortsInterface
import DBKitInterface

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
            
            let collection: [TimelineCollection] = .init(from: result)
            return collection.sorted(by: { $0.date > $1.date })
        } catch {
            return []
        }
    }
}
 
extension Timeline {
    init(from consumption: ConsumptionModel) {
        self.init(time: consumption.time, consumed: consumption.consumed)
    }
}

extension TimelineCollection {
    init?(dateString: String, timeline: [Timeline]) {
        guard let date = DatabaseFormatter.date.date(from: dateString) else { return nil }
        
        self.init(
            date: date,
            timeline: timeline
        )
    }
}

extension Array where Element == TimelineCollection {
    init(from consumption: [ConsumptionModel]) {
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
