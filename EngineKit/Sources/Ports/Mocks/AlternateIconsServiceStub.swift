//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

import PortsInterface

public protocol AlternateIconsServiceStubbing {
    var supportsAlternateIcons_returnValue: Bool { get set }
    var setAlternateIcon_returnValue: Error? { get set }
    var getAlternateIcon_returnValue: String? { get set }
}

public final class AlternateIconsServiceStub: AlternateIconsServiceStubbing {
    public init() {}
    
    public var supportsAlternateIcons_returnValue: Bool = false
    public var setAlternateIcon_returnValue: Error?
    public var getAlternateIcon_returnValue: String?
}

extension AlternateIconsServiceStub: AlternateIconsServiceType {
    public func supportsAlternateIcons() async -> Bool {
        supportsAlternateIcons_returnValue
    }
    
    public func setAlternateIcon(to iconName: String) async -> Error? {
        if let setAlternateIcon_returnValue {
            return setAlternateIcon_returnValue
        } else {
            getAlternateIcon_returnValue = iconName
            return nil
        }
    }
    
    public func getAlternateIcon() async -> String? {
        getAlternateIcon_returnValue
    }
}
