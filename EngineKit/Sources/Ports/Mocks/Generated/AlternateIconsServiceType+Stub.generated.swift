// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import PortsInterface

public protocol AlternateIconsServiceTypeStubbing {
    var supportsAlternateIcons_returnValue: Bool { get set }
    var setAlternateIconIconName_returnValue: Error? { get set }
    var getAlternateIcon_returnValue: String? { get set }
}

public final class AlternateIconsServiceTypeStub: AlternateIconsServiceTypeStubbing {
    public var supportsAlternateIcons_returnValue: Bool = .default
    public var setAlternateIconIconName_returnValue: Error? = nil
    public var getAlternateIcon_returnValue: String? = nil

    public init() {}
}

extension AlternateIconsServiceTypeStub: AlternateIconsServiceType {
    public func supportsAlternateIcons() async -> Bool {
        supportsAlternateIcons_returnValue
    }

    public func setAlternateIcon(to iconName: String) async -> Error? {
        setAlternateIconIconName_returnValue
    }

    public func getAlternateIcon() async -> String? {
        getAlternateIcon_returnValue
    }

}
