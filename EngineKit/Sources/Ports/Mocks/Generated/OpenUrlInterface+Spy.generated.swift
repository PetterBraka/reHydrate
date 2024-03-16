// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
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
