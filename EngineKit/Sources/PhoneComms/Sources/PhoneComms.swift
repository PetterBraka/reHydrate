//
//  PhoneComms.swift
//
//
//  Created by Petter vang Brakalsvålet on 11/08/2024.
//

import Foundation
import LoggingService
import DateServiceInterface
import PhoneCommsInterface
import DayServiceInterface
import DrinkServiceInterface
import UnitServiceInterface
import CommunicationKitInterface

public final class PhoneComms {
    public typealias Engine = (
        HasLoggingService &
        HasDateService &
        HasDayService &
        HasDrinksService &
        HasUnitService &
        HasPhoneService
    )
    
    private let engine: Engine
    private let notificationCenter: NotificationCenter
    private var updateBlock: (() -> Void)?
    
    public init(engine: Engine, notificationCenter: NotificationCenter) {
        self.engine = engine
        self.notificationCenter = notificationCenter
        
    }
    
    deinit {
    }
}

extension PhoneComms: PhoneCommsType {
    public func setAppContext() async {
    }
    
    public func sendDataToWatch() async {
    }
    
    public func addObserver(using updateBlock: @escaping () -> Void) {
    }
    
    public func removeObserver() {
    }
}
