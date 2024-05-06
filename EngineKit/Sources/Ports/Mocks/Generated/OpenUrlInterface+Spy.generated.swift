// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import PortsInterface

public protocol OpenUrlInterfaceSpying {
    var variableLog: [OpenUrlInterfaceSpy.VariableName] { get set }
    var lastVariabelCall: OpenUrlInterfaceSpy.VariableName? { get }
    var methodLog: [OpenUrlInterfaceSpy.MethodCall] { get set }
    var lastMethodCall: OpenUrlInterfaceSpy.MethodCall? { get }
}

public final class OpenUrlInterfaceSpy: OpenUrlInterfaceSpying {
    public enum VariableName {
        case settingsUrl
    }

    public enum MethodCall {
        case open(url: URL)
        case email(email: String, cc: String?, bcc: String?, subject: String, body: String?)
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
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
        methodLog.append(.open(url: url))
        try await realObject.open(url: url)
    }
    public func email(to email: String, cc: String?, bcc: String?, subject: String, body: String?) async throws -> Void {
        methodLog.append(.email(email: email, cc: cc, bcc: bcc, subject: subject, body: body))
        try await realObject.email(to: email, cc: cc, bcc: bcc, subject: subject, body: body)
    }
}
