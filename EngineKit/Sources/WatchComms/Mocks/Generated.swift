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
    }

    public enum MethodName {
        case setAppContext
        case sendDataToPhone
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
        }
    }
}

extension WatchCommsTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setAppContext: "setAppContext"
        case .sendDataToPhone: "sendDataToPhone"
        }
    }
}

extension WatchCommsTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.setAppContext, .setAppContext): true
        case (.sendDataToPhone, .sendDataToPhone): true
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

}
