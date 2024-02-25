// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import TimelineServiceInterface

public protocol TimelineServiceTypeStubbing {
    var getTimelineDate_returnValue: [Timeline] { get set }
    var getTimelineCollection_returnValue: [TimelineCollection] { get set }
}

public final class TimelineServiceTypeStub: TimelineServiceTypeStubbing {
    public var getTimelineDate_returnValue: [Timeline] = .default
    public var getTimelineCollection_returnValue: [TimelineCollection] = .default

    public init() {}
}

extension TimelineServiceTypeStub: TimelineServiceType {
    public func getTimeline(for date: Date) async -> [Timeline] {
        getTimelineDate_returnValue
    }

    public func getTimelineCollection() async -> [TimelineCollection] {
        getTimelineCollection_returnValue
    }

}
