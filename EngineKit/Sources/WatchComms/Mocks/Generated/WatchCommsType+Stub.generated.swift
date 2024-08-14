// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import WatchCommsInterface

public protocol WatchCommsTypeStubbing {
}

public final class WatchCommsTypeStub: WatchCommsTypeStubbing {

    public init() {}
}

extension WatchCommsTypeStub: WatchCommsType {
    public func setAppContext() async -> Void {
    }

    public func sendDataToPhone() async -> Void {
    }

    public func addObserver(using updateBlock: @escaping () -> Void) -> Void {
    }

    public func removeObserver() -> Void {
    }

}
