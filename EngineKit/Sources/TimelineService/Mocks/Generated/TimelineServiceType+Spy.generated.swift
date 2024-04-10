// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import TimelineServiceInterface

public protocol TimelineServiceTypeSpying {
    var variableLog: [TimelineServiceTypeSpy.VariableName] { get set }
    var lastvariabelCall: TimelineServiceTypeSpy.VariableName? { get }
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
    public var lastvariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private let realObject: TimelineServiceType
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
