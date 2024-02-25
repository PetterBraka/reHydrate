// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
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
