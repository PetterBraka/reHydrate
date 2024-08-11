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
        
        addWatchObservers()
    }
    
    deinit {
        removeWatchObservers()
    }
}

extension PhoneComms: PhoneCommsType {
    public func setAppContext() async {
        guard canSendData()
        else {
            engine.logger.warning("Couldn't send data", error: nil)
            return
        }
        
        let data = await getPhoneData()
        await sendAppContext(data)
    }
    
    public func sendDataToWatch() async {
        guard canSendData()
        else {
            engine.logger.warning("Couldn't send data", error: nil)
            return
        }
        
        let data = await getPhoneData()
        if engine.phoneService.isComplicationEnabled,
           engine.phoneService.remainingComplicationUserInfoTransfers > 0 {
            await sendComplication(data)
        } else {
            await sendMessage(data)
        }
    }
    
    public func addObserver(using updateBlock: @escaping () -> Void) {
        self.updateBlock = updateBlock
    }
    
    public func removeObserver() {
        self.updateBlock = nil
    }
}

private extension PhoneComms {
    func canSendData() -> Bool {
        engine.phoneService.isSupported() &&
        engine.phoneService.currentState == .activated &&
        engine.phoneService.isPaired &&
        engine.phoneService.isWatchAppInstalled
    }
    
    func getPhoneData() async -> [CommunicationUserInfo: Codable] {
        await [
            .day: engine.dayService.getToday(),
            .drinks: try? engine.drinksService.getSaved(),
            .unitSystem: engine.unitService.getUnitSystem()
        ]
    }
    
    func sendMessage(_ data: [CommunicationUserInfo: Codable]) async {
        engine.phoneService.sendMessage(data) { [weak self] error in
            self?.engine.logger.error("Failed sending \(data) to watchOS device", error: error)
        }
    }
    
    func sendComplication(_ data: [CommunicationUserInfo: Codable]) async {
        _ = engine.phoneService.transferComplication(userInfo: data)
    }
    
    func sendAppContext(_ data: [CommunicationUserInfo: Codable]) async {
        do {
            try engine.phoneService.update(applicationContext: data)
        } catch {
            engine.logger.error("Failed updating context \(data) to watchOS device", error: error)
        }
    }
}

private extension PhoneComms {
    func addWatchObservers() {
        notificationCenter.addObserver(forName: .Shared.didReceiveApplicationContext,
                                       object: nil, queue: .current,
                                       using: process(notification:))
        notificationCenter.addObserver(forName: .Shared.didReceiveMessage,
                                       object: nil, queue: .current,
                                       using: process(notification:))
        notificationCenter.addObserver(forName: .Shared.didReceiveUserInfo,
                                       object: nil, queue: .current,
                                       using: process(notification:))
    }
    
    func removeWatchObservers() {
        notificationCenter.removeObserver(self, name: .Shared.didReceiveApplicationContext, object: nil)
        notificationCenter.removeObserver(self, name: .Shared.didReceiveMessage, object: nil)
        notificationCenter.removeObserver(self, name: .Shared.didReceiveUserInfo, object: nil)
    }
    
    func process(notification: Notification) {
        let watchInfo = notification.userInfo?.mapKeysAndValues()
        Task {
            await process(day: watchInfo?[.day])
            await process(drinks: watchInfo?[.drinks])
            process(unitSystem: watchInfo?[.unitSystem])
            
            updateBlock?()
        }
    }
    
    func process(day data: Data?) async {
        let today = await engine.dayService.getToday()
        
        guard let data,
              let day = try? JSONDecoder().decode(Day.self, from: data),
              engine.dateService.isDate(day.date, inSameDayAs: today.date)
        else {
            return
        }
        
        let consumedDiff = today.consumed - day.consumed
        let size = engine.unitService.convert(abs(consumedDiff), from: .litres, to: .millilitres)
        let drink = Drink(id: "watch-message", size: size, container: .medium)
        if consumedDiff < 0 {
            _ = try? await engine.dayService.add(drink: drink)
        } else if consumedDiff > 0 {
            _ = try? await engine.dayService.remove(drink: drink)
        }
        
        let goalDiff = today.goal - day.goal
        if goalDiff < 0 {
            _ = try? await engine.dayService.increase(goal: goalDiff)
        } else if goalDiff > 0 {
            _ = try? await engine.dayService.decrease(goal: abs(goalDiff))
        }
    }
    
    func process(drinks data: Data?) async {
        let drinks = try? await engine.drinksService.getSaved()
        guard let data,
              let watchDrinks = try? JSONDecoder().decode([Drink].self, from: data),
              watchDrinks != drinks
        else { return }
        
        for watchDrink in watchDrinks {
            if drinks?.contains(where: { $0.container == watchDrink.container }) == true {
                do {
                    _ = try await engine.drinksService.edit(
                        size: watchDrink.size,
                        of: watchDrink.container
                    )
                } catch {
                    engine.logger.error("Failed to update drink to \(watchDrink)", error: error)
                }
            } else {
                do {
                    _ = try await engine.drinksService.add(
                        size: watchDrink.size,
                        container: watchDrink.container
                    )
                } catch {
                    engine.logger.error("Failed to add drink to \(watchDrink)", error: error)
                }
            }
        }
    }
    
    func process(unitSystem data: Data?) {
        guard let data,
              let watchUnitSystem = try? JSONDecoder().decode(UnitSystem.self, from: data),
              watchUnitSystem != engine.unitService.getUnitSystem()
        else { return }
        
        engine.unitService.set(unitSystem: watchUnitSystem)
    }
}

fileprivate extension Dictionary where Key == AnyHashable {
    func mapKeysAndValues() -> [CommunicationUserInfo: Data]{
        reduce(into: [CommunicationUserInfo: Data]()) { partialResult, element in
            guard let key = CommunicationUserInfo(rawValue: "\(element.key)") else { return }
            partialResult[key] = element.value as? Data
        }
    }
}
