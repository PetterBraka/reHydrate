// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import WatchCommsInterface

public protocol WatchCommsTypeSpying {
    var variableLog: [WatchCommsTypeSpy.VariableName] { get set }
    var lastVariabelCall: WatchCommsTypeSpy.VariableName? { get }
    var methodLog: [WatchCommsTypeSpy.MethodCall] { get set }
    var lastMethodCall: WatchCommsTypeSpy.MethodCall? { get }
}

public final class WatchCommsTypeSpy: WatchCommsTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case setAppContext
        case sendDataToPhone
        case addObserver(updateBlock: () -> Void)
        case removeObserver
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: WatchCommsType
    public init(realObject: WatchCommsType) {
        self.realObject = realObject
    }
}

extension WatchCommsTypeSpy: WatchCommsType {
    public func setAppContext() async -> Void {
        methodLog.append(.setAppContext)
        await realObject.setAppContext()
    }
    public func sendDataToPhone() async -> Void {
        methodLog.append(.sendDataToPhone)
        await realObject.sendDataToPhone()
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
