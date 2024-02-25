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
}// swiftlint:disable line_length
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
}// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol HealthInterfaceSpying {
    var variableLog: [HealthInterfaceSpy.VariableName] { get set }
    var methodLog: [HealthInterfaceSpy.MethodName] { get set }
}

public final class HealthInterfaceSpy: HealthInterfaceSpying {
    public enum VariableName {
            case isSupported
    }

    public enum MethodName {
            case shouldRequestAccess_for
            case canWrite
            case requestAuth_toReadAndWrite
            case export_quantity_id_date
            case read_queryType
            case enableBackgroundDelivery_healthData_frequency
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: HealthInterface
    public init(realObject: HealthInterface) {
        self.realObject = realObject
    }
}

extension HealthInterfaceSpy: HealthInterface {
    public var isSupported: Bool {
        get {
            variableLog.append(.isSupported)
            return realObject.isSupported
        }
    }
    public func shouldRequestAccess(for healthDataType: [HealthDataType]) async -> Bool {
        methodLog.append(.shouldRequestAccess_for)
        return await realObject.shouldRequestAccess(for: healthDataType)
    }
    public func canWrite(_ dataType: HealthDataType) -> Bool {
        methodLog.append(.canWrite)
        return realObject.canWrite(dataType)
    }
    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws -> Void {
        methodLog.append(.requestAuth_toReadAndWrite)
        try await realObject.requestAuth(toReadAndWrite: readAndWrite)
    }
    public func export(quantity: Quantity, id: QuantityTypeIdentifier, date: Date) async throws -> Void {
        methodLog.append(.export_quantity_id_date)
        try await realObject.export(quantity: quantity, id: id, date: date)
    }
    public func read(_ data: HealthDataType, queryType: HealthQuery) -> Void {
        methodLog.append(.read_queryType)
        realObject.read(data, queryType: queryType)
    }
    public func enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency) async throws -> Void {
        methodLog.append(.enableBackgroundDelivery_healthData_frequency)
        try await realObject.enableBackgroundDelivery(healthData: healthData, frequency: frequency)
    }
}// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol OpenUrlInterfaceSpying {
    var variableLog: [OpenUrlInterfaceSpy.VariableName] { get set }
    var methodLog: [OpenUrlInterfaceSpy.MethodName] { get set }
}

public final class OpenUrlInterfaceSpy: OpenUrlInterfaceSpying {
    public enum VariableName {
            case settingsUrl
    }

    public enum MethodName {
            case open_url
            case email_to_cc_bcc_subject_body
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: OpenUrlInterface
    public init(realObject: OpenUrlInterface) {
        self.realObject = realObject
    }
}

extension OpenUrlInterfaceSpy: OpenUrlInterface {
    public var settingsUrl: URL? {
        get {
            variableLog.append(.settingsUrl)
            return realObject.settingsUrl
        }
    }
    public func open(url: URL) async throws -> Void {
        methodLog.append(.open_url)
        try await realObject.open(url: url)
    }
    public func email(to email: String, cc: String?, bcc: String?, subject: String, body: String?) async throws -> Void {
        methodLog.append(.email_to_cc_bcc_subject_body)
        try await realObject.email(to: email, cc: cc, bcc: bcc, subject: subject, body: body)
    }
}
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol AlternateIconsServiceTypeStubbing {
    var supportsAlternateIcons_returnValue: Bool { get set }
    var setAlternateIconIconName_returnValue: Error? { get set }
    var getAlternateIcon_returnValue: String? { get set }
}

public final class AlternateIconsServiceTypeStub: AlternateIconsServiceTypeStubbing {
    public var supportsAlternateIcons_returnValue: Bool = .default
    public var setAlternateIconIconName_returnValue: Error? = nil
    public var getAlternateIcon_returnValue: String? = nil

    public init() {}
}

extension AlternateIconsServiceTypeStub: AlternateIconsServiceType {
    public func supportsAlternateIcons() async -> Bool {
        supportsAlternateIcons_returnValue
    }

    public func setAlternateIcon(to iconName: String) async -> Error? {
        setAlternateIconIconName_returnValue
    }

    public func getAlternateIcon() async -> String? {
        getAlternateIcon_returnValue
    }

}

import Foundation
import PortsInterface

public protocol AppearancePortTypeStubbing {
    var getStyle_returnValue: Style? { get set }
    var setStyleStyle_returnValue: Error? { get set }
}

public final class AppearancePortTypeStub: AppearancePortTypeStubbing {
    public var getStyle_returnValue: Style? = nil
    public var setStyleStyle_returnValue: Error? = nil

    public init() {}
}

extension AppearancePortTypeStub: AppearancePortType {
    public func getStyle() -> Style? {
        getStyle_returnValue
    }

    public func setStyle(_ style: Style) throws -> Void {
        if let setStyleStyle_returnValue {
            throw setStyleStyle_returnValue
        }
    }

}

import Foundation
import PortsInterface

public protocol HealthInterfaceStubbing {
    var isSupported_returnValue: Bool { get set }
    var shouldRequestAccessHealthDataType_returnValue: Bool { get set }
    var canWriteDataType_returnValue: Bool { get set }
    var requestAuthReadAndWrite_returnValue: Error? { get set }
    var exportQuantityIdDate_returnValue: Error? { get set }
    var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? { get set }
}

public final class HealthInterfaceStub: HealthInterfaceStubbing {
    public var isSupported_returnValue: Bool = .default
    public var shouldRequestAccessHealthDataType_returnValue: Bool = .default
    public var canWriteDataType_returnValue: Bool = .default
    public var requestAuthReadAndWrite_returnValue: Error? = nil
    public var exportQuantityIdDate_returnValue: Error? = nil
    public var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? = nil

    public init() {}
}

extension HealthInterfaceStub: HealthInterface {
    public var isSupported: Bool { isSupported_returnValue }
    public func shouldRequestAccess(for healthDataType: [HealthDataType]) async -> Bool {
        shouldRequestAccessHealthDataType_returnValue
    }

    public func canWrite(_ dataType: HealthDataType) -> Bool {
        canWriteDataType_returnValue
    }

    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws -> Void {
        if let requestAuthReadAndWrite_returnValue {
            throw requestAuthReadAndWrite_returnValue
        }
    }

    public func export(quantity: Quantity, id: QuantityTypeIdentifier, date: Date) async throws -> Void {
        if let exportQuantityIdDate_returnValue {
            throw exportQuantityIdDate_returnValue
        }
    }

    public func read(_ data: HealthDataType, queryType: HealthQuery) -> Void {
    }

    public func enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency) async throws -> Void {
        if let enableBackgroundDeliveryHealthDataFrequency_returnValue {
            throw enableBackgroundDeliveryHealthDataFrequency_returnValue
        }
    }

}

import Foundation
import PortsInterface

public protocol OpenUrlInterfaceStubbing {
    var settingsUrl_returnValue: URL? { get set }
    var openUrl_returnValue: Error? { get set }
    var emailEmailCcBccSubjectBody_returnValue: Error? { get set }
}

public final class OpenUrlInterfaceStub: OpenUrlInterfaceStubbing {
    public var settingsUrl_returnValue: URL? = .default
    public var openUrl_returnValue: Error? = nil
    public var emailEmailCcBccSubjectBody_returnValue: Error? = nil

    public init() {}
}

extension OpenUrlInterfaceStub: OpenUrlInterface {
    public var settingsUrl: URL? { settingsUrl_returnValue }
    public func open(url: URL) async throws -> Void {
        if let openUrl_returnValue {
            throw openUrl_returnValue
        }
    }

    public func email(to email: String, cc: String?, bcc: String?, subject: String, body: String?) async throws -> Void {
        if let emailEmailCcBccSubjectBody_returnValue {
            throw emailEmailCcBccSubjectBody_returnValue
        }
    }

}

