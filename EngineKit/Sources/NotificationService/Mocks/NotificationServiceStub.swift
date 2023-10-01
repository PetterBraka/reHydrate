//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/09/2023.
//

import Foundation
import NotificationServiceInterface

public protocol NotificationServiceStubbing {
    var enable_returnValue: Result<Void, NotificationError> { get set }
    var getSettings_returnValue: NotificationSettings { get set }
}

public final class NotificationServiceStub: NotificationServiceStubbing {
    public init() {}
    
    public var enable_returnValue: Result<Void, NotificationError> = .success(Void())
    public var getSettings_returnValue: NotificationSettings = .init(isOn: false, start: nil, stop: nil, frequency: nil)
}

extension NotificationServiceStub: NotificationServiceType {
    public func enable(withFrequency: Int, startTime: String, stopTime: String) async -> Result<Void, NotificationError> {
        enable_returnValue
    }
    
    public func disable() {}
    
    public func getSettings() -> NotificationSettings {
        getSettings_returnValue
    }
}
