//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

import Foundation
import CommunicationKitInterface

public protocol HasPorts:
    HasOpenUrlService &
    HasAlternateIconsService &
    HasAppearancePort &
    HasHealthService &
    HasWatchService &
    HasPhoneService
{}
