// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol AlternateIconsServiceTypeSpying {
    var variableLog: [AlternateIconsServiceTypeSpy.VariableName] { get set }
    var methodLog: [AlternateIconsServiceTypeSpy.MethodName] { get set }
}

public final class AlternateIconsServiceTypeSpy: AlternateIconsServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
        case supportsAlternateIcons
        case setAlternateIcon_to
        case getAlternateIcon
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: AlternateIconsServiceType
    public init(realObject: AlternateIconsServiceType) {
        self.realObject = realObject
    }
}

extension AlternateIconsServiceTypeSpy: AlternateIconsServiceType {
    public func supportsAlternateIcons() async -> Bool {
        methodLog.append(.supportsAlternateIcons)
        return await realObject.supportsAlternateIcons()
    }
    public func setAlternateIcon(to iconName: String) async -> Error? {
        methodLog.append(.setAlternateIcon_to)
        return await realObject.setAlternateIcon(to: iconName)
    }
    public func getAlternateIcon() async -> String? {
        methodLog.append(.getAlternateIcon)
        return await realObject.getAlternateIcon()
    }
}
