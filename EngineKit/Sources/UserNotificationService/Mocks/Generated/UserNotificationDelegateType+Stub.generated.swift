// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import UserNotificationServiceInterface

public protocol UserNotificationDelegateTypeStubbing {
}

public final class UserNotificationDelegateTypeStub: UserNotificationDelegateTypeStubbing {

    public init() {}
}

extension UserNotificationDelegateTypeStub: UserNotificationDelegateType {
    public func userNotificationCenter(_ center: UserNotificationCenterType, didReceive response: NotificationResponse) async -> Void {
    }

    public func userNotificationCenter(_ center: UserNotificationCenterType, willPresent: DeliveredNotification) async -> Void {
    }

    public func userNotificationCenter(_ center: UserNotificationCenterType, openSettingsFor: DeliveredNotification?) -> Void {
    }

}
