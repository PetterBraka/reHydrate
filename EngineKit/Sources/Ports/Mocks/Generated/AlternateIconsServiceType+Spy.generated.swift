// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol AlternateIconsServiceTypeSpying {
    var variableLog: [AlternateIconsServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: AlternateIconsServiceTypeSpy.VariableName? { get }
    var methodLog: [AlternateIconsServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: AlternateIconsServiceTypeSpy.MethodCall? { get }
}

public final class AlternateIconsServiceTypeSpy: AlternateIconsServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case supportsAlternateIcons
        case setAlternateIcon(iconName: String)
        case getAlternateIcon
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
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
        methodLog.append(.setAlternateIcon(iconName: iconName))
        return await realObject.setAlternateIcon(to: iconName)
    }
    public func getAlternateIcon() async -> String? {
        methodLog.append(.getAlternateIcon)
        return await realObject.getAlternateIcon()
    }
}
