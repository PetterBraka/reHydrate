// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import NotificationServiceInterface

public protocol NotificationDelegateTypeStubbing {
}

public final class NotificationDelegateTypeStub: NotificationDelegateTypeStubbing {

    public init() {}
}

extension NotificationDelegateTypeStub: NotificationDelegateType {
    public func userNotificationCenter(_ center: NotificationCenterType, didReceive response: NotificationResponse) async -> Void {
    }

    public func userNotificationCenter(_ center: NotificationCenterType, willPresent: DeliveredNotification) async -> Void {
    }

    public func userNotificationCenter(_ center: NotificationCenterType, openSettingsFor: DeliveredNotification?) -> Void {
    }

}
