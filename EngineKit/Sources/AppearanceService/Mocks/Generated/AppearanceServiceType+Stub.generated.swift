// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import AppearanceServiceInterface

public protocol AppearanceServiceTypeStubbing {
    var getAppearance_returnValue: Appearance { get set }
}

public final class AppearanceServiceTypeStub: AppearanceServiceTypeStubbing {
    public var getAppearance_returnValue: Appearance {
        get {
            if getAppearance_returnValues.count > 0 {
                let value = getAppearance_returnValues.removeFirst()
                if getAppearance_returnValues.isEmpty {
                    getAppearance_returnValues.insert(value, at: 0)
                }
                return value
            } else {
                return getAppearance_returnValues.first ?? .default
            }
        }
        set {
            getAppearance_returnValues.append(newValue)
        }
    }
    private var getAppearance_returnValues: [Appearance] = []

    public init() {}
}

extension AppearanceServiceTypeStub: AppearanceServiceType {
    public func getAppearance() -> Appearance {
        getAppearance_returnValue
    }

    public func setAppearance(_ appearance: Appearance) -> Void {
    }

}
