// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import TimelineServiceInterface

public protocol TimelineServiceTypeSpying {
    var variableLog: [TimelineServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: TimelineServiceTypeSpy.VariableName? { get }
    var methodLog: [TimelineServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: TimelineServiceTypeSpy.MethodCall? { get }
}

public final class TimelineServiceTypeSpy: TimelineServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case getTimeline(date: Date)
        case getTimelineCollection
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: TimelineServiceType
    public init(realObject: TimelineServiceType) {
        self.realObject = realObject
    }
}

extension TimelineServiceTypeSpy: TimelineServiceType {
    public func getTimeline(for date: Date) async -> [Timeline] {
        methodLog.append(.getTimeline(date: date))
        return await realObject.getTimeline(for: date)
    }
    public func getTimelineCollection() async -> [TimelineCollection] {
        methodLog.append(.getTimelineCollection)
        return await realObject.getTimelineCollection()
    }
}
// MARK: - AutoString
// swiftlint:disable all



// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import TimelineServiceInterface

public protocol TimelineServiceTypeStubbing {
    var getTimelineDate_returnValue: [Timeline] { get set }
    var getTimelineCollection_returnValue: [TimelineCollection] { get set }
}

public final class TimelineServiceTypeStub: TimelineServiceTypeStubbing {
    public var getTimelineDate_returnValue: [Timeline] {
        get {
            if getTimelineDate_returnValues.isEmpty {
                .default
            } else {
                getTimelineDate_returnValues.removeFirst()
            }
        }
        set {
            getTimelineDate_returnValues.append(newValue)
        }
    }
    private var getTimelineDate_returnValues: [[Timeline]] = []
    public var getTimelineCollection_returnValue: [TimelineCollection] {
        get {
            if getTimelineCollection_returnValues.isEmpty {
                .default
            } else {
                getTimelineCollection_returnValues.removeFirst()
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
