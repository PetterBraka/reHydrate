// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import PortsInterface

public protocol AlternateIconsServiceTypeSpying {
    var variableLog: [AlternateIconsServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: AlternateIconsServiceTypeSpy.VariableName? { get }
    var methodLog: [AlternateIconsServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: AlternateIconsServiceTypeSpy.MethodCall? { get }
    var methodNameLog: [AlternateIconsServiceTypeSpy.MethodName] { get set }
}

public final class AlternateIconsServiceTypeSpy: AlternateIconsServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case supportsAlternateIcons
        case setAlternateIconIconName(iconName: String)
        case getAlternateIcon
    }

    public enum MethodName {
        case supportsAlternateIcons
        case setAlternateIconIconName
        case getAlternateIcon
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: AlternateIconsServiceType
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
        methodLog.append(.setAlternateIconIconName(iconName: iconName))
        return await realObject.setAlternateIcon(to: iconName)
    }
    public func getAlternateIcon() async -> String? {
        methodLog.append(.getAlternateIcon)
        return await realObject.getAlternateIcon()
    }
}

extension AlternateIconsServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension AlternateIconsServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .supportsAlternateIcons: "supportsAlternateIcons"
        case .setAlternateIconIconName(let iconName): "setAlternateIcon(iconName: \(String(describing: iconName)))"
        case .getAlternateIcon: "getAlternateIcon"
        }
    }
}

extension AlternateIconsServiceTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .supportsAlternateIcons: "supportsAlternateIcons"
        case .setAlternateIconIconName: "setAlternateIconIconName"
        case .getAlternateIcon: "getAlternateIcon"
        }
    }
}

import Foundation
import PortsInterface

public protocol AppearancePortTypeSpying {
    var variableLog: [AppearancePortTypeSpy.VariableName] { get set }
    var lastVariabelCall: AppearancePortTypeSpy.VariableName? { get }
    var methodLog: [AppearancePortTypeSpy.MethodCall] { get set }
    var lastMethodCall: AppearancePortTypeSpy.MethodCall? { get }
    var methodNameLog: [AppearancePortTypeSpy.MethodName] { get set }
}

public final class AppearancePortTypeSpy: AppearancePortTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case getStyle
        case setStyleStyle(style: Style)
    }

    public enum MethodName {
        case getStyle
        case setStyleStyle
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
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
        methodLog.append(.setStyleStyle(style: style))
        try realObject.setStyle(style)
    }
}

extension AppearancePortTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension AppearancePortTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .getStyle: "getStyle"
        case .setStyleStyle(let style): "setStyle(style: \(String(describing: style)))"
        }
    }
}

extension AppearancePortTypeSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .getStyle: "getStyle"
        case .setStyleStyle: "setStyleStyle"
        }
    }
}

import Foundation
import PortsInterface

public protocol HealthInterfaceSpying {
    var variableLog: [HealthInterfaceSpy.VariableName] { get set }
    var lastVariabelCall: HealthInterfaceSpy.VariableName? { get }
    var methodLog: [HealthInterfaceSpy.MethodCall] { get set }
    var lastMethodCall: HealthInterfaceSpy.MethodCall? { get }
    var methodNameLog: [HealthInterfaceSpy.MethodName] { get set }
}

public final class HealthInterfaceSpy: HealthInterfaceSpying {
    public enum VariableName {
        case isSupported
    }

    public enum MethodCall {
        case shouldRequestAccessHealthDataType(healthDataType: [HealthDataType])
        case canWriteDataType(dataType: HealthDataType)
        case requestAuthReadAndWrite(readAndWrite: Set<HealthDataType>)
        case exportQuantityIdDate(quantity: Quantity, id: QuantityTypeIdentifier, date: Date)
        case readSumDataStartEndIntervalComponents(data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents)
        case readSamplesDataStartEnd(data: HealthDataType, start: Date, end: Date)
        case enableBackgroundDeliveryHealthDataFrequency(healthData: HealthDataType, frequency: HealthFrequency)
    }

    public enum MethodName {
        case shouldRequestAccessHealthDataType
        case canWriteDataType
        case requestAuthReadAndWrite
        case exportQuantityIdDate
        case readSumDataStartEndIntervalComponents
        case readSamplesDataStartEnd
        case enableBackgroundDeliveryHealthDataFrequency
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: HealthInterface
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
        methodLog.append(.shouldRequestAccessHealthDataType(healthDataType: healthDataType))
        return await realObject.shouldRequestAccess(for: healthDataType)
    }
    public func canWrite(_ dataType: HealthDataType) -> Bool {
        methodLog.append(.canWriteDataType(dataType: dataType))
        return realObject.canWrite(dataType)
    }
    public func requestAuth(toReadAndWrite readAndWrite: Set<HealthDataType>) async throws -> Void {
        methodLog.append(.requestAuthReadAndWrite(readAndWrite: readAndWrite))
        try await realObject.requestAuth(toReadAndWrite: readAndWrite)
    }
    public func export(quantity: Quantity, id: QuantityTypeIdentifier, date: Date) async throws -> Void {
        methodLog.append(.exportQuantityIdDate(quantity: quantity, id: id, date: date))
        try await realObject.export(quantity: quantity, id: id, date: date)
    }
    public func readSum(_ data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents) async throws -> Double {
        methodLog.append(.readSumDataStartEndIntervalComponents(data: data, start: start, end: end, intervalComponents: intervalComponents))
        return try await realObject.readSum(data, start: start, end: end, intervalComponents: intervalComponents)
    }
    public func readSamples(_ data: HealthDataType, start: Date, end: Date) async throws -> [Double] {
        methodLog.append(.readSamplesDataStartEnd(data: data, start: start, end: end))
        return try await realObject.readSamples(data, start: start, end: end)
    }
    public func enableBackgroundDelivery(healthData: HealthDataType, frequency: HealthFrequency) async throws -> Void {
        methodLog.append(.enableBackgroundDeliveryHealthDataFrequency(healthData: healthData, frequency: frequency))
        try await realObject.enableBackgroundDelivery(healthData: healthData, frequency: frequency)
    }
}

extension HealthInterfaceSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .isSupported: "isSupported"
        }
    }
}

extension HealthInterfaceSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .shouldRequestAccessHealthDataType(let healthDataType): "shouldRequestAccess(healthDataType: \(String(describing: healthDataType)))"
        case .canWriteDataType(let dataType): "canWrite(dataType: \(String(describing: dataType)))"
        case .requestAuthReadAndWrite(let readAndWrite): "requestAuth(readAndWrite: \(String(describing: readAndWrite)))"
        case .exportQuantityIdDate(let quantity, let id, let date): "export(quantity: \(String(describing: quantity)), id: \(String(describing: id)), date: \(String(describing: date)))"
        case .readSumDataStartEndIntervalComponents(let data, let start, let end, let intervalComponents): "readSum(data: \(String(describing: data)), start: \(String(describing: start)), end: \(String(describing: end)), intervalComponents: \(String(describing: intervalComponents)))"
        case .readSamplesDataStartEnd(let data, let start, let end): "readSamples(data: \(String(describing: data)), start: \(String(describing: start)), end: \(String(describing: end)))"
        case .enableBackgroundDeliveryHealthDataFrequency(let healthData, let frequency): "enableBackgroundDelivery(healthData: \(String(describing: healthData)), frequency: \(String(describing: frequency)))"
        }
    }
}

extension HealthInterfaceSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .shouldRequestAccessHealthDataType: "shouldRequestAccessHealthDataType"
        case .canWriteDataType: "canWriteDataType"
        case .requestAuthReadAndWrite: "requestAuthReadAndWrite"
        case .exportQuantityIdDate: "exportQuantityIdDate"
        case .readSumDataStartEndIntervalComponents: "readSumDataStartEndIntervalComponents"
        case .readSamplesDataStartEnd: "readSamplesDataStartEnd"
        case .enableBackgroundDeliveryHealthDataFrequency: "enableBackgroundDeliveryHealthDataFrequency"
        }
    }
}

import Foundation
import PortsInterface

public protocol OpenUrlInterfaceSpying {
    var variableLog: [OpenUrlInterfaceSpy.VariableName] { get set }
    var lastVariabelCall: OpenUrlInterfaceSpy.VariableName? { get }
    var methodLog: [OpenUrlInterfaceSpy.MethodCall] { get set }
    var lastMethodCall: OpenUrlInterfaceSpy.MethodCall? { get }
    var methodNameLog: [OpenUrlInterfaceSpy.MethodName] { get set }
}

public final class OpenUrlInterfaceSpy: OpenUrlInterfaceSpying {
    public enum VariableName {
        case settingsUrl
    }

    public enum MethodCall {
        case openUrl(url: URL)
        case emailEmailCcBccSubjectBody(email: String, cc: String?, bcc: String?, subject: String, body: String?)
    }

    public enum MethodName {
        case openUrl
        case emailEmailCcBccSubjectBody
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    public var methodNameLog: [MethodName] = []
    private var realObject: OpenUrlInterface
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
        methodLog.append(.openUrl(url: url))
        try await realObject.open(url: url)
    }
    public func email(to email: String, cc: String?, bcc: String?, subject: String, body: String?) async throws -> Void {
        methodLog.append(.emailEmailCcBccSubjectBody(email: email, cc: cc, bcc: bcc, subject: subject, body: body))
        try await realObject.email(to: email, cc: cc, bcc: bcc, subject: subject, body: body)
    }
}

extension OpenUrlInterfaceSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .settingsUrl: "settingsUrl"
        }
    }
}

extension OpenUrlInterfaceSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .openUrl(let url): "open(url: \(String(describing: url)))"
        case .emailEmailCcBccSubjectBody(let email, let cc, let bcc, let subject, let body): "email(email: \(String(describing: email)), cc: \(String(describing: cc)), bcc: \(String(describing: bcc)), subject: \(String(describing: subject)), body: \(String(describing: body)))"
        }
    }
}

extension OpenUrlInterfaceSpy.MethodName: CustomStringConvertible {
    public var description: String {
        switch self {
        case .openUrl: "openUrl"
        case .emailEmailCcBccSubjectBody: "emailEmailCcBccSubjectBody"
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import PortsInterface


// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import PortsInterface

public protocol AlternateIconsServiceTypeStubbing {
    var supportsAlternateIcons_returnValue: Bool { get set }
    var setAlternateIconIconName_returnValue: Error? { get set }
    var getAlternateIcon_returnValue: String? { get set }
}

public final class AlternateIconsServiceTypeStub: AlternateIconsServiceTypeStubbing {
    public var supportsAlternateIcons_returnValue: Bool {
        get {
            if supportsAlternateIcons_returnValues.isEmpty {
                .default
            } else {
                supportsAlternateIcons_returnValues.removeFirst()
            }
        }
        set {
            supportsAlternateIcons_returnValues.append(newValue)
        }
    }
    private var supportsAlternateIcons_returnValues: [Bool] = []
    public var setAlternateIconIconName_returnValue: Error? {
        get {
            if setAlternateIconIconName_returnValues.isEmpty {
                .default
            } else {
                setAlternateIconIconName_returnValues.removeFirst()
            }
        }
        set {
            setAlternateIconIconName_returnValues.append(newValue)
        }
    }
    private var setAlternateIconIconName_returnValues: [Error?] = []
    public var getAlternateIcon_returnValue: String? {
        get {
            if getAlternateIcon_returnValues.isEmpty {
                .default
            } else {
                getAlternateIcon_returnValues.removeFirst()
            }
        }
        set {
            getAlternateIcon_returnValues.append(newValue)
        }
    }
    private var getAlternateIcon_returnValues: [String?] = []

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
    public var getStyle_returnValue: Style? {
        get {
            if getStyle_returnValues.isEmpty {
                .default
            } else {
                getStyle_returnValues.removeFirst()
            }
        }
        set {
            getStyle_returnValues.append(newValue)
        }
    }
    private var getStyle_returnValues: [Style?] = []
    public var setStyleStyle_returnValue: Error? {
        get {
            if setStyleStyle_returnValues.isEmpty {
                nil
            } else {
                setStyleStyle_returnValues.removeFirst()
            }
        }
        set {
            setStyleStyle_returnValues.append(newValue)
        }
    }
    private var setStyleStyle_returnValues: [Error?] = []

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
    var readSumDataStartEndIntervalComponents_returnValue: Result<Double, Error> { get set }
    var readSamplesDataStartEnd_returnValue: Result<[Double], Error> { get set }
    var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? { get set }
}

public final class HealthInterfaceStub: HealthInterfaceStubbing {
    public var isSupported_returnValue: Bool {
        get {
            if isSupported_returnValues.isEmpty {
                .default
            } else {
                isSupported_returnValues.removeFirst()
            }
        }
        set {
            isSupported_returnValues.append(newValue)
        }
    }
    private var isSupported_returnValues: [Bool] = []
    public var shouldRequestAccessHealthDataType_returnValue: Bool {
        get {
            if shouldRequestAccessHealthDataType_returnValues.isEmpty {
                .default
            } else {
                shouldRequestAccessHealthDataType_returnValues.removeFirst()
            }
        }
        set {
            shouldRequestAccessHealthDataType_returnValues.append(newValue)
        }
    }
    private var shouldRequestAccessHealthDataType_returnValues: [Bool] = []
    public var canWriteDataType_returnValue: Bool {
        get {
            if canWriteDataType_returnValues.isEmpty {
                .default
            } else {
                canWriteDataType_returnValues.removeFirst()
            }
        }
        set {
            canWriteDataType_returnValues.append(newValue)
        }
    }
    private var canWriteDataType_returnValues: [Bool] = []
    public var requestAuthReadAndWrite_returnValue: Error? {
        get {
            if requestAuthReadAndWrite_returnValues.isEmpty {
                nil
            } else {
                requestAuthReadAndWrite_returnValues.removeFirst()
            }
        }
        set {
            requestAuthReadAndWrite_returnValues.append(newValue)
        }
    }
    private var requestAuthReadAndWrite_returnValues: [Error?] = []
    public var exportQuantityIdDate_returnValue: Error? {
        get {
            if exportQuantityIdDate_returnValues.isEmpty {
                nil
            } else {
                exportQuantityIdDate_returnValues.removeFirst()
            }
        }
        set {
            exportQuantityIdDate_returnValues.append(newValue)
        }
    }
    private var exportQuantityIdDate_returnValues: [Error?] = []
    public var readSumDataStartEndIntervalComponents_returnValue: Result<Double, Error> {
        get {
            if readSumDataStartEndIntervalComponents_returnValues.isEmpty {
                .default
            } else {
                readSumDataStartEndIntervalComponents_returnValues.removeFirst()
            }
        }
        set {
            readSumDataStartEndIntervalComponents_returnValues.append(newValue)
        }
    }
    private var readSumDataStartEndIntervalComponents_returnValues: [Result<Double, Error>] = []
    public var readSamplesDataStartEnd_returnValue: Result<[Double], Error> {
        get {
            if readSamplesDataStartEnd_returnValues.isEmpty {
                .default
            } else {
                readSamplesDataStartEnd_returnValues.removeFirst()
            }
        }
        set {
            readSamplesDataStartEnd_returnValues.append(newValue)
        }
    }
    private var readSamplesDataStartEnd_returnValues: [Result<[Double], Error>] = []
    public var enableBackgroundDeliveryHealthDataFrequency_returnValue: Error? {
        get {
            if enableBackgroundDeliveryHealthDataFrequency_returnValues.isEmpty {
                nil
            } else {
                enableBackgroundDeliveryHealthDataFrequency_returnValues.removeFirst()
            }
        }
        set {
            enableBackgroundDeliveryHealthDataFrequency_returnValues.append(newValue)
        }
    }
    private var enableBackgroundDeliveryHealthDataFrequency_returnValues: [Error?] = []

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

    public func readSum(_ data: HealthDataType, start: Date, end: Date, intervalComponents: DateComponents) async throws -> Double {
        switch readSumDataStartEndIntervalComponents_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    public func readSamples(_ data: HealthDataType, start: Date, end: Date) async throws -> [Double] {
        switch readSamplesDataStartEnd_returnValue {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
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
    public var settingsUrl_returnValue: URL? {
        get {
            if settingsUrl_returnValues.isEmpty {
                .default
            } else {
                settingsUrl_returnValues.removeFirst()
            }
        }
        set {
            if let newValue {
                settingsUrl_returnValues.append(newValue)
            }
        }
    }
    private var settingsUrl_returnValues: [URL?] = []
    public var openUrl_returnValue: Error? {
        get {
            if openUrl_returnValues.isEmpty {
                nil
            } else {
                openUrl_returnValues.removeFirst()
            }
        }
        set {
            openUrl_returnValues.append(newValue)
        }
    }
    private var openUrl_returnValues: [Error?] = []
    public var emailEmailCcBccSubjectBody_returnValue: Error? {
        get {
            if emailEmailCcBccSubjectBody_returnValues.isEmpty {
                nil
            } else {
                emailEmailCcBccSubjectBody_returnValues.removeFirst()
            }
        }
        set {
            emailEmailCcBccSubjectBody_returnValues.append(newValue)
        }
    }
    private var emailEmailCcBccSubjectBody_returnValues: [Error?] = []

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
