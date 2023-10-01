//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/09/2023.
//

import Foundation
import NotificationServiceInterface

public protocol NotificationServiceStubbing {
    var isOn_returnValue: Bool { get set }
    var enable_returnValue: Result<Void, NotificationError> { get set }
}

public final class NotificationServiceStub: NotificationServiceStubbing {
    public init() {}
    
    public var isOn_returnValue: Bool = false
    public var enable_returnValue: Result<Void, NotificationError> = .success(Void())
}

extension NotificationServiceStub: NotificationServiceType {
    public var isOn: Bool {
        isOn_returnValue
    public func enable(withFrequency: Int, startTime: String, stopTime: String) async -> Result<Void, NotificationError> {
        enable_returnValue
    }
    
    
    public func disable() {
        isOn_returnValue = false
    }
    
}
