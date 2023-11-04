//
//  AppearanceServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

public protocol AppearancePortType {
    func getStyle() -> Style?
    func setStyle(_ style: Style) throws
}
