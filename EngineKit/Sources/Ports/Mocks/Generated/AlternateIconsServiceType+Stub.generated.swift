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
    public var supportsAlternateIcons_returnValue: Bool {
        get {
            if supportsAlternateIcons_returnValues.first != nil {
                supportsAlternateIcons_returnValues.removeFirst()
            } else {
                .default
            }
        }
        set {
            supportsAlternateIcons_returnValues.append(newValue)
        }
    }
    private var supportsAlternateIcons_returnValues: [Bool] = []
    public var setAlternateIconIconName_returnValue: Error? {
        get {
            if setAlternateIconIconName_returnValues.first != nil {
                setAlternateIconIconName_returnValues.removeFirst()
            } else {
                nil
            }
        }
        set {
            setAlternateIconIconName_returnValues.append(newValue)
        }
    }
    private var setAlternateIconIconName_returnValues: [Error?] = []
    public var getAlternateIcon_returnValue: String? {
        get {
            if getAlternateIcon_returnValues.first != nil {
                getAlternateIcon_returnValues.removeFirst()
            } else {
                nil
            }
        }
        set {
            getAlternateIcon_returnValues.append(newValue)
        }
    }
    private var getAlternateIcon_returnValues: [String?] = []

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
