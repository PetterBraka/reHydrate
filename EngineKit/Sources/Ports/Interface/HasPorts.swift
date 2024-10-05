//
//  HasPorts.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

public protocol HasPorts:
    HasOpenUrlService,
    HasAlternateIconsService,
    HasAppearancePort,
    HasHealthService,
    HasNotificationCenterPort
{}
