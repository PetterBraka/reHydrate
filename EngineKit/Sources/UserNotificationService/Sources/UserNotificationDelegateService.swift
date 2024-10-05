//
//  UserNotificationDelegateService.swift
//
//
//  Created by Petter vang Brakalsvålet on 02/10/2023.
//

import LoggingService
import DayServiceInterface
import DrinkServiceInterface
import UserNotificationServiceInterface

public final class UserNotificationDelegateService: UserNotificationDelegateType {
    public typealias Engine = (
        HasLoggingService &
        HasDayService &
        HasDrinksService
    )
    
    private let engine: Engine
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    public func userNotificationCenter(
        _ center: UserNotificationCenterType,
        openSettingsFor: DeliveredNotification?
    ) {}
    
    public func userNotificationCenter(
        _ center: UserNotificationCenterType,
        willPresent: DeliveredNotification
    ) async {}
    
    public func userNotificationCenter(
        _ center: UserNotificationCenterType,
        didReceive response: NotificationResponse
    ) async {
        let actionId = response.actionIdentifier
        do {
            let drinks = try await engine.drinksService.getSaved()
            guard let drink = drinks.first(where: { $0.container.rawValue == actionId })
            else {
                engine.logger.debug("Unexpected action selected - \(actionId)")
                return
            }

            do {
                _ = try await engine.dayService.add(drink: drink)
            } catch {
                engine.logger.error("Couldn't add drink(\(drink)) from notification", error: error)
            }
        } catch {
            engine.logger.critical("No drinks found", error: error)
        }
    }
}
