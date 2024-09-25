// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol AppearancePortTypeSpying {
    var variableLog: [AppearancePortTypeSpy.VariableName] { get set }
    var lastVariabelCall: AppearancePortTypeSpy.VariableName? { get }
    var methodLog: [AppearancePortTypeSpy.MethodCall] { get set }
    var lastMethodCall: AppearancePortTypeSpy.MethodCall? { get }
}

public final class AppearancePortTypeSpy: AppearancePortTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case getStyle
        case setStyle(style: Style)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: AppearancePortType
    public init(realObject: AppearancePortType) {
        self.realObject = realObject
    }
}

extension AppearancePortTypeSpy: AppearancePortType {
    public func getStyle() -> Style? {
        methodLog.append(.getStyle)
        return realObject.getStyle()
    }
    public func setStyle(_ style: Style) throws -> Void {
        methodLog.append(.setStyle(style: style))
        try realObject.setStyle(style)
    }
}
