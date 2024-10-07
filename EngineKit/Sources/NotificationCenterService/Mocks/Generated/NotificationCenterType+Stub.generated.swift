// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import NotificationCenterServiceInterface

public protocol NotificationCenterTypeStubbing {
}

public final class NotificationCenterTypeStub: NotificationCenterTypeStubbing {

    public init() {}
}

extension NotificationCenterTypeStub: NotificationCenterType {
    public func post(name: NotificationName) -> Void {
    }

    public func addObserver(_ observer: Any, name: NotificationName, selector: Selector, object: Any?) -> Void {
    }

    public func removeObserver(_ observer: Any, name: NotificationName) -> Void {
    }

}
