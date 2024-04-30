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
    public var getTimelineDate_returnValue: [Timeline] {
        get {
            if getTimelineDate_returnValues.count > 0 {
                let value = getTimelineDate_returnValues.removeFirst()
                if getTimelineDate_returnValues.isEmpty {
                    getTimelineDate_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getTimelineDate_returnValues.first ?? .default
            }
        }
        set {
            getTimelineDate_returnValues.append(newValue)
        }
    }
    private var getTimelineDate_returnValues: [[Timeline]] = []
    public var getTimelineCollection_returnValue: [TimelineCollection] {
        get {
            if getTimelineCollection_returnValues.count > 0 {
                let value = getTimelineCollection_returnValues.removeFirst()
                if getTimelineCollection_returnValues.isEmpty {
                    getTimelineCollection_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getTimelineCollection_returnValues.first ?? .default
            }
        }
        set {
            getTimelineCollection_returnValues.append(newValue)
        }
    }
    private var getTimelineCollection_returnValues: [[TimelineCollection]] = []

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
