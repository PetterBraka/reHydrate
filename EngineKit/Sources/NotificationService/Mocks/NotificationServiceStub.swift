//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/09/2023.
//

import Foundation
import NotificationServiceInterface

public protocol NotificationServiceStubbing {
    var minimumAllowedFrequency_returnValue: Int { get set }
    var enable_returnValue: Result<Void, NotificationError> { get set }
    var getSettings_returnValue: NotificationSettings { get set }
}

public final class NotificationServiceStub: NotificationServiceStubbing {
    public init() {}
    
    public var minimumAllowedFrequency_returnValue: Int = 10
    public var enable_returnValue: Result<Void, NotificationError> = .success(Void())
    public var getSettings_returnValue: NotificationSettings = .init(isOn: false, start: nil, stop: nil, frequency: nil)
}

extension NotificationServiceStub: NotificationServiceType {
    public var minimumAllowedFrequency: Int {
        minimumAllowedFrequency_returnValue
    }
    
    public func enable(withFrequency: Int, start: Date, stop: Date) async -> Result<Void, NotificationError> {
        enable_returnValue
    }
    
    public func disable() {}
    
    public func getSettings() -> NotificationSettings {
        getSettings_returnValue
    }
}
