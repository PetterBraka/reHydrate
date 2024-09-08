//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

import Foundation

public protocol HasPorts:
    HasOpenUrlService,
    HasAlternateIconsService,
    HasAppearancePort,
    HasHealthService
{}
