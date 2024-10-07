// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import NotificationCenterServiceInterface

public protocol NotificationCenterTypeSpying {
    var variableLog: [NotificationCenterTypeSpy.VariableName] { get set }
    var lastVariabelCall: NotificationCenterTypeSpy.VariableName? { get }
    var methodLog: [NotificationCenterTypeSpy.MethodCall] { get set }
    var lastMethodCall: NotificationCenterTypeSpy.MethodCall? { get }
}

public final class NotificationCenterTypeSpy: NotificationCenterTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case post(name: NotificationName)
        case addObserver(observer: Any, name: NotificationName, selector: Selector, object: Any?)
        case removeObserver(observer: Any, name: NotificationName)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: NotificationCenterType
    public init(realObject: NotificationCenterType) {
        self.realObject = realObject
    }
}

extension NotificationCenterTypeSpy: NotificationCenterType {
    public func post(name: NotificationName) -> Void {
        methodLog.append(.post(name: name))
        realObject.post(name: name)
    }
    public func addObserver(_ observer: Any, name: NotificationName, selector: Selector, object: Any?) -> Void {
        methodLog.append(.addObserver(observer: observer, name: name, selector: selector, object: object))
        realObject.addObserver(observer, name: name, selector: selector, object: object)
    }
    public func removeObserver(_ observer: Any, name: NotificationName) -> Void {
        methodLog.append(.removeObserver(observer: observer, name: name))
        realObject.removeObserver(observer, name: name)
    }
}
