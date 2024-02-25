// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol AppearancePortTypeSpying {
    var variableLog: [AppearancePortTypeSpy.VariableName] { get set }
    var methodLog: [AppearancePortTypeSpy.MethodName] { get set }
}

public final class AppearancePortTypeSpy: AppearancePortTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
            case getStyle
            case setStyle
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: AppearancePortType
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
        methodLog.append(.setStyle)
        try realObject.setStyle(style)
    }
}
