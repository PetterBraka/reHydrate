//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

import Foundation
import PortsInterface

public protocol OpenUrlServiceStubbing {
    var settingsUrl_returnValue: URL? { get }
    var openUrl_returnValue: Error? { get }
    var email_returnValue: Error? { get }
}

public final class OpenUrlServiceStub: OpenUrlServiceStubbing {
    public init() {}
    
    public var settingsUrl_returnValue: URL?
    public var openUrl_returnValue: Error?
    public var email_returnValue: Error?
}

extension OpenUrlServiceStub: OpenUrlInterface {
    public var settingsUrl: URL? {
        settingsUrl_returnValue
    }
    
    public func open(url: URL) async throws {
        if let openUrl_returnValue {
            throw openUrl_returnValue
        }
    }
    
    public func email(to email: String, cc: String?, bcc: String?, subject: String, body: String?) async throws {
        if let email_returnValue {
            throw email_returnValue
        }
    }
}
