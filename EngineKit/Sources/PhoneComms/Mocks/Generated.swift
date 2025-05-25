// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoEquatable
// swiftlint:disable all

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import PhoneCommsInterface

public protocol PhoneCommsTypeSpying {
    var variableLog: [PhoneCommsTypeSpy.VariableName] { get set }
    var lastVariabelCall: PhoneCommsTypeSpy.VariableName? { get }
    var methodLog: [PhoneCommsTypeSpy.MethodCall] { get set }
    var lastMethodCall: PhoneCommsTypeSpy.MethodCall? { get }
    var methodNameLog: [PhoneCommsTypeSpy.MethodName] { get set }
}

public final class PhoneCommsTypeSpy: PhoneCommsTypeSpying {
    public enum VariableName: Equatable {
    }

    public enum MethodCall {
        case setAppContext
        case sendDataToWatch
    }

    public enum MethodName {
        case setAppContext
        case sendDataToWatch
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: PhoneCommsType
    public init(realObject: PhoneCommsType) {
        self.realObject = realObject
    }
}

extension PhoneCommsTypeSpy: PhoneCommsType {
    public func setAppContext() async -> Void {
        methodNameLog.append(.setAppContext)
        methodLog.append(.setAppContext)
        await realObject.setAppContext()
    }
    public func sendDataToWatch() async -> Void {
        methodNameLog.append(.sendDataToWatch)
        methodLog.append(.sendDataToWatch)
        await realObject.sendDataToWatch()
    }
}

extension PhoneCommsTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension PhoneCommsTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setAppContext: "setAppContext"
        case .sendDataToWatch: "sendDataToWatch"
        }
    }
}

extension PhoneCommsTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setAppContext: "setAppContext"
        case .sendDataToWatch: "sendDataToWatch"
        }
    }
}

extension PhoneCommsTypeSpy.MethodCall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.setAppContext, .setAppContext): true
        case (.sendDataToWatch, .sendDataToWatch): true
        default: false
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import PhoneCommsInterface


// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import PhoneCommsInterface

public protocol PhoneCommsTypeStubbing {
}

public final class PhoneCommsTypeStub: PhoneCommsTypeStubbing {

    public init() {}
}

extension PhoneCommsTypeStub: PhoneCommsType {
    public func setAppContext() async -> Void {
    }

    public func sendDataToWatch() async -> Void {
    }

}
