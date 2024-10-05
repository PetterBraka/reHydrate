//
//  NotificationCenterPort.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 05/10/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import PortsInterface

public final class NotificationCenterService: NotificationCenterPort {
    private let notificationCenter: NotificationCenter
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    public func post(name: NotificationName) {
        notificationCenter.post(name: .init(from: name), object: self)
    }
    
    public func addObserver(
        _ observer: Any,
        name: NotificationName,
        selector: Selector,
        object: Any?
    ) {
        notificationCenter.addObserver(observer, selector: selector, name: .init(from: name), object: object)
    }
    
    public func removeObserver(_ observer: Any, name: NotificationName) {
        notificationCenter.removeObserver(observer, name: .init(from: name), object: nil)
    }
}

extension Notification.Name {
    init(from name: NotificationName) {
        self = .init(name.name)
    }
}
