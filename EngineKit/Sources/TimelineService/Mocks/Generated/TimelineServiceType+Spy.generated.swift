// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import TimelineServiceInterface

public protocol TimelineServiceTypeSpying {
    var variableLog: [TimelineServiceTypeSpy.VariableName] { get set }
    var methodLog: [TimelineServiceTypeSpy.MethodName] { get set }
}

public final class TimelineServiceTypeSpy: TimelineServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
        case getTimeline_for
        case getTimelineCollection
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: TimelineServiceType
    public init(realObject: TimelineServiceType) {
        self.realObject = realObject
    }
}

extension TimelineServiceTypeSpy: TimelineServiceType {
    public func getTimeline(for date: Date) async -> [Timeline] {
        methodLog.append(.getTimeline_for)
        return await realObject.getTimeline(for: date)
    }
    public func getTimelineCollection() async -> [TimelineCollection] {
        methodLog.append(.getTimelineCollection)
        return await realObject.getTimelineCollection()
    }
}
