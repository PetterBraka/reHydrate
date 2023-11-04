//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

import PortsInterface

public protocol AppearancePortStubbing {
    var getStyle_returnValue: Style? { get set}
    var setStyle_returnValue: Error? { get set}
}

public final class AppearancePortStub: AppearancePortStubbing {
    public init() {}
    
    public var getStyle_returnValue: Style?
    public var setStyle_returnValue: Error?
}

extension AppearancePortStub: AppearancePortType {
    public func getStyle() -> Style? {
        getStyle_returnValue
    }
    
    public func setStyle(_ style: Style) throws {
        if let setStyle_returnValue {
            throw setStyle_returnValue
        }
        getStyle_returnValue = style
    }
}
