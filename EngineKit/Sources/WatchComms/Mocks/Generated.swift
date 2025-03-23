// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoEquatable
// swiftlint:disable all

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import WatchCommsInterface

public protocol WatchCommsTypeSpying {
    var variableLog: [WatchCommsTypeSpy.VariableName] { get set }
    var lastVariabelCall: WatchCommsTypeSpy.VariableName? { get }
    var methodLog: [WatchCommsTypeSpy.MethodCall] { get set }
    var lastMethodCall: WatchCommsTypeSpy.MethodCall? { get }
    var methodNameLog: [WatchCommsTypeSpy.MethodName] { get set }
}

public final class WatchCommsTypeSpy: WatchCommsTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case setAppContext
        case sendDataToPhone
        case addObserverUpdateBlock(updateBlock: () -> Void)
        case removeObserver
    }

    public enum MethodName {
        case setAppContext
        case sendDataToPhone
        case addObserverUpdateBlock
        case removeObserver
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: WatchCommsType
    public init(realObject: WatchCommsType) {
        self.realObject = realObject
    }
}

extension WatchCommsTypeSpy: WatchCommsType {
    public func setAppContext() async -> Void {
        methodNameLog.append(.setAppContext)
        methodLog.append(.setAppContext)
        await realObject.setAppContext()
    }
    public func sendDataToPhone() async -> Void {
        methodNameLog.append(.sendDataToPhone)
        methodLog.append(.sendDataToPhone)
        await realObject.sendDataToPhone()
    }
    public func addObserver(using updateBlock: @escaping () -> Void) -> Void {
        methodNameLog.append(.addObserverUpdateBlock)
        methodLog.append(.addObserverUpdateBlock(updateBlock: updateBlock))
        realObject.addObserver(using: updateBlock)
    }
    public func removeObserver() -> Void {
        methodNameLog.append(.removeObserver)
        methodLog.append(.removeObserver)
        realObject.removeObserver()
    }
}

extension WatchCommsTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension WatchCommsTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setAppContext: "setAppContext"
        case .sendDataToPhone: "sendDataToPhone"
        case .addObserverUpdateBlock(let updateBlock): "addObserver(updateBlock: \(String(describing: updateBlock)))"
        case .removeObserver: "removeObserver"
        }
    }
}

extension WatchCommsTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setAppContext: "setAppContext"
        case .sendDataToPhone: "sendDataToPhone"
        case .addObserverUpdateBlock: "addObserverUpdateBlock"
        case .removeObserver: "removeObserver"
        }
    }
}

extension WatchCommsTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.setAppContext, .setAppContext): true
        case (.sendDataToPhone, .sendDataToPhone): true
        case (.addObserverUpdateBlock(let lhs_updateBlock), .addObserverUpdateBlock(let rhs_updateBlock)): lhs_updateBlock() == rhs_updateBlock()
        case (.removeObserver, .removeObserver): true
        default: false
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import WatchCommsInterface


// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import WatchCommsInterface

public protocol WatchCommsTypeStubbing {
}

public final class WatchCommsTypeStub: WatchCommsTypeStubbing {

    public init() {}
}

extension WatchCommsTypeStub: WatchCommsType {
    public func setAppContext() async -> Void {
    }

    public func sendDataToPhone() async -> Void {
    }

    public func addObserver(using updateBlock: @escaping () -> Void) -> Void {
    }

    public func removeObserver() -> Void {
    }

}
