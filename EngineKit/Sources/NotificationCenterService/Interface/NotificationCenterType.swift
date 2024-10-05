//
//  NotificationCenterType.swift
//  EngineKit
//
//  Created by Petter vang Brakalsvålet on 05/10/2024.
//

import Foundation

public protocol NotificationCenterType: AnyObject {
    func post(name: NotificationName)
    func addObserver(
        _ observer: Any,
        name: NotificationName,
        selector: Selector,
        object: Any?
    )
    func removeObserver(_ observer: Any, name: NotificationName)
}
