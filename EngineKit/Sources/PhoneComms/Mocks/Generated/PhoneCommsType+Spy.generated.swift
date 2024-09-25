// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

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
        case addObserver(updateBlock: () -> Void)
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
        methodLog.append(.addObserver(updateBlock: updateBlock))
        realObject.addObserver(using: updateBlock)
    }
    public func removeObserver() -> Void {
        methodLog.append(.removeObserver)
        realObject.removeObserver()
    }
}
