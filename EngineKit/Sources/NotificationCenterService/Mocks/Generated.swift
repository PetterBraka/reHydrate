// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoEquatable
// swiftlint:disable all

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import NotificationCenterServiceInterface

public protocol NotificationCenterTypeSpying {
    var variableLog: [NotificationCenterTypeSpy.VariableName] { get set }
    var lastVariabelCall: NotificationCenterTypeSpy.VariableName? { get }
    var methodLog: [NotificationCenterTypeSpy.MethodCall] { get set }
    var lastMethodCall: NotificationCenterTypeSpy.MethodCall? { get }
    var methodNameLog: [NotificationCenterTypeSpy.MethodName] { get set }
}

public final class NotificationCenterTypeSpy: NotificationCenterTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case postName(name: NotificationName)
        case addObserverObserverNameSelectorObject(observer: Any, name: NotificationName, selector: Selector, object: Any?)
        case removeObserverObserverName(observer: Any, name: NotificationName)
    }

    public enum MethodName {
        case postName
        case addObserverObserverNameSelectorObject
        case removeObserverObserverName
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: NotificationCenterType
    public init(realObject: NotificationCenterType) {
        self.realObject = realObject
    }
}

extension NotificationCenterTypeSpy: NotificationCenterType {
    public func post(name: NotificationName) -> Void {
        methodNameLog.append(.postName)
        methodLog.append(.postName(name: name))
        realObject.post(name: name)
    }
    public func addObserver(_ observer: Any, name: NotificationName, selector: Selector, object: Any?) -> Void {
        methodNameLog.append(.addObserverObserverNameSelectorObject)
        methodLog.append(.addObserverObserverNameSelectorObject(observer: observer, name: name, selector: selector, object: object))
        realObject.addObserver(observer, name: name, selector: selector, object: object)
    }
    public func removeObserver(_ observer: Any, name: NotificationName) -> Void {
        methodNameLog.append(.removeObserverObserverName)
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
        case .postName(let name): "post(name: \(String(describing: name)))"
        case .addObserverObserverNameSelectorObject(let observer, let name, let selector, let object): "addObserver(observer: \(String(describing: observer)), name: \(String(describing: name)), selector: \(String(describing: selector)), object: \(String(describing: object)))"
        case .removeObserverObserverName(let observer, let name): "removeObserver(observer: \(String(describing: observer)), name: \(String(describing: name)))"
        }
    }
}

extension NotificationCenterTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .postName: "postName"
        case .addObserverObserverNameSelectorObject: "addObserverObserverNameSelectorObject"
        case .removeObserverObserverName: "removeObserverObserverName"
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
