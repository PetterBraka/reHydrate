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
        HasLoggerService &
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
                engine.logger.log(category: .userNotificationService, message: "Unexpected action selected - \(actionId)", error: nil, level: .debug)
                return
            }

            do {
                _ = try await engine.dayService.add(drink: drink)
            } catch {
                engine.logger.log(category: .userNotificationService, message: "Couldn't add drink(\(drink)) from notification", error: error, level: .error)
            }
        } catch {
            engine.logger.log(category: .userNotificationService, message: "No drinks found", error: error, level: .error)
        }
    }
}
