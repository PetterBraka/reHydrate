// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import PortsInterface

public protocol AppearancePortTypeStubbing {
    var getStyle_returnValue: Style? { get set }
    var setStyleStyle_returnValue: Error? { get set }
}

public final class AppearancePortTypeStub: AppearancePortTypeStubbing {
    public var getStyle_returnValue: Style? {
        get {
            if getStyle_returnValues.first != nil {
                getStyle_returnValues.removeFirst()
            } else {
                nil
            }
        }
        set {
            getStyle_returnValues.append(newValue)
        }
    }
    private var getStyle_returnValues: [Style?] = []
    public var setStyleStyle_returnValue: Error? {
        get {
            if setStyleStyle_returnValues.first != nil {
                setStyleStyle_returnValues.removeFirst()
            } else {
                nil
            }
        }
        set {
            setStyleStyle_returnValues.append(newValue)
        }
    }
    private var setStyleStyle_returnValues: [Error?] = []

    public init() {}
}

extension AppearancePortTypeStub: AppearancePortType {
    public func getStyle() -> Style? {
        getStyle_returnValue
    }

    public func setStyle(_ style: Style) throws -> Void {
        if let setStyleStyle_returnValue {
            throw setStyleStyle_returnValue
        }
    }

}
