// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

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
        case postName(name: NotificationName)
        case addObserverObserverNameSelectorObject(observer: Any, name: NotificationName, selector: Selector, object: Any?)
        case removeObserverObserverName(observer: Any, name: NotificationName)
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
        methodLog.append(.postName(name: name))
        realObject.post(name: name)
    }
    public func addObserver(_ observer: Any, name: NotificationName, selector: Selector, object: Any?) -> Void {
        methodLog.append(.addObserverObserverNameSelectorObject(observer: observer, name: name, selector: selector, object: object))
        realObject.addObserver(observer, name: name, selector: selector, object: object)
    }
    public func removeObserver(_ observer: Any, name: NotificationName) -> Void {
        methodLog.append(.removeObserverObserverName(observer: observer, name: name))
        realObject.removeObserver(observer, name: name)
    }
}

extension NotificationCenterTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension NotificationCenterTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .postName(let name): "post(\(String(describing: name)))"
        case .addObserverObserverNameSelectorObject(let observer, let name, let selector, let object): "addObserver(\(String(describing: observer)), \(String(describing: name)), \(String(describing: selector)), \(String(describing: object)))"
        case .removeObserverObserverName(let observer, let name): "removeObserver(\(String(describing: observer)), \(String(describing: name)))"
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import NotificationCenterServiceInterface


// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import NotificationCenterServiceInterface

public protocol NotificationCenterTypeStubbing {
}

public final class NotificationCenterTypeStub: NotificationCenterTypeStubbing {

    public init() {}
}

extension NotificationCenterTypeStub: NotificationCenterType {
    public func post(name: NotificationName) -> Void {
    }

    public func addObserver(_ observer: Any, name: NotificationName, selector: Selector, object: Any?) -> Void {
    }

    public func removeObserver(_ observer: Any, name: NotificationName) -> Void {
    }

}
