//
//  AppearanceServiceStub.swift
//
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

import AppearanceServiceInterface

public protocol AppearanceServiceStubbing {
    var getAppearance_returnValue: Appearance { get set }
}

public final class AppearanceServiceStub: AppearanceServiceStubbing {
    public init() {}
    
    public var getAppearance_returnValue: Appearance = .light
}

extension AppearanceServiceStub: AppearanceServiceType {
    public func getAppearance() -> Appearance {
        getAppearance_returnValue
    }
    
    public func setAppearance(_ appearance: Appearance) {
        getAppearance_returnValue = appearance
    }
}
