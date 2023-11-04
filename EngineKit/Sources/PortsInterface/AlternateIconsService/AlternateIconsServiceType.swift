//
//  AlternateIconsServiceType.swift
//
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//

public protocol AlternateIconsServiceType {
    func supportsAlternateIcons() async -> Bool
    func setAlternateIcon(to iconName: String) async -> Error?
    func getAlternateIcon() async -> String?
}
