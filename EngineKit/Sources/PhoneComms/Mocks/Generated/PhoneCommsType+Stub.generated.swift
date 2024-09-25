// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import PhoneCommsInterface

public protocol PhoneCommsTypeStubbing {
}

public final class PhoneCommsTypeStub: PhoneCommsTypeStubbing {

    public init() {}
}

extension PhoneCommsTypeStub: PhoneCommsType {
    public func setAppContext() async -> Void {
    }

    public func sendDataToWatch() async -> Void {
    }

    public func addObserver(using updateBlock: @escaping () -> Void) -> Void {
    }

    public func removeObserver() -> Void {
    }

}
