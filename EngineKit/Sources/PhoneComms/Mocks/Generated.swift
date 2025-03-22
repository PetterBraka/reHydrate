// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import PhoneCommsInterface

public protocol PhoneCommsTypeSpying {
    var variableLog: [PhoneCommsTypeSpy.VariableName] { get set }
    var lastVariabelCall: PhoneCommsTypeSpy.VariableName? { get }
    var methodLog: [PhoneCommsTypeSpy.MethodCall] { get set }
    var lastMethodCall: PhoneCommsTypeSpy.MethodCall? { get }
}

public final class PhoneCommsTypeSpy: PhoneCommsTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case setAppContext
        case sendDataToWatch
        case addObserverUpdateBlock(updateBlock: () -> Void)
        case removeObserver
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: PhoneCommsType
    public init(realObject: PhoneCommsType) {
        self.realObject = realObject
    }
}

extension PhoneCommsTypeSpy: PhoneCommsType {
    public func setAppContext() async -> Void {
        methodLog.append(.setAppContext)
        await realObject.setAppContext()
    }
    public func sendDataToWatch() async -> Void {
        methodLog.append(.sendDataToWatch)
        await realObject.sendDataToWatch()
    }
    public func addObserver(using updateBlock: @escaping () -> Void) -> Void {
        methodLog.append(.addObserverUpdateBlock(updateBlock: updateBlock))
        realObject.addObserver(using: updateBlock)
    }
    public func removeObserver() -> Void {
        methodLog.append(.removeObserver)
        realObject.removeObserver()
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
        case .setAppContext: "setAppContext("
        case .sendDataToWatch: "sendDataToWatch("
        case .addObserverUpdateBlock(let updateBlock): "addObserver(\(String(describing: updateBlock)))"
        case .removeObserver: "removeObserver("
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

    public func addObserver(using updateBlock: @escaping () -> Void) -> Void {
    }

    public func removeObserver() -> Void {
    }

}
