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
        HasLoggerService &
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
            engine.logger.log(category: .phoneComms, message: "Couldn't send data", error: nil, level: .info)
            return
        }
        
        let data = await getPhoneData()
        await sendAppContext(data)
    }
    
    public func sendDataToWatch() async {
        guard canSendData()
        else {
            engine.logger.log(category: .phoneComms, message: "Couldn't send data", error: nil, level: .info)
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
        var data: [CommunicationUserInfo: Codable] = await [
            .day: engine.dayService.getToday(),
            .unitSystem: engine.unitService.getUnitSystem()
        ]
        if let drinks = try? await engine.drinksService.getSaved(){
            data[.drinks] = drinks
        }
        return data
    }
    
    func sendMessage(_ data: [CommunicationUserInfo: Codable]) async {
        engine.phoneService.sendMessage(data) { [weak self] error in
            self?.engine.logger.log(category: .phoneComms, message: "Failed sending \(data) to watchOS device", error: error, level: .error)
        }
    }
    
    func sendComplication(_ data: [CommunicationUserInfo: Codable]) async {
        _ = engine.phoneService.transferComplication(userInfo: data)
    }
    
    func sendAppContext(_ data: [CommunicationUserInfo: Codable]) async {
        do {
            try engine.phoneService.update(applicationContext: data)
        } catch {
            engine.logger.log(category: .phoneComms, message: "Failed updating context \(data) to watchOS device", error: error, level: .error)
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
        guard let watchData = notification.userInfo?.mapKeysAndValues() else { return }
        Task {
            await process(day: watchData[.day])
            await process(drinks: watchData[.drinks])
            process(unitSystem: watchData[.unitSystem])
            
            updateBlock?()
        }
    }
    
    func process(day data: Data?) async {
        guard let data,
              let day = try? JSONDecoder().decode(Day.self, from: data)
        else { return }
        
        let today = await engine.dayService.getToday()
        guard engine.dateService.isDate(day.date, inSameDayAs: today.date)
        else { return }
        
        let consumedDiff = today.consumed - day.consumed
        if consumedDiff != 0 {
            let size = engine.unitService.convert(abs(consumedDiff), from: .litres, to: .millilitres)
            let drink = Drink(id: "watch-message", size: size, container: .medium)
            if consumedDiff < 0 {
                _ = try? await engine.dayService.add(drink: drink)
            } else if consumedDiff > 0 {
                _ = try? await engine.dayService.remove(drink: drink)
            }
        }
        
        let goalDiff = today.goal - day.goal
        if goalDiff < 0 {
            _ = try? await engine.dayService.increase(goal: abs(goalDiff))
        } else if goalDiff > 0 {
            _ = try? await engine.dayService.decrease(goal: abs(goalDiff))
        }
    }
    
    func process(drinks data: Data?) async {
        guard let data,
              let watchDrinks = try? JSONDecoder().decode([Drink].self, from: data)
        else { return }
        
        let drinks = try? await engine.drinksService.getSaved()
        guard watchDrinks != drinks else { return }
        
        for watchDrink in watchDrinks {
            if drinks?.contains(where: { $0.container == watchDrink.container }) == true {
                do {
                    _ = try await engine.drinksService.edit(
                        size: watchDrink.size,
                        of: watchDrink.container
                    )
                } catch {
                    engine.logger.log(category: .phoneComms, message: "Failed to update drink to \(watchDrink)", error: error, level: .error)
                }
            } else {
                do {
                    _ = try await engine.drinksService.add(
                        size: watchDrink.size,
                        container: watchDrink.container
                    )
                } catch {
                    engine.logger.log(category: .phoneComms, message: "Failed to add drink to \(watchDrink)", error: error, level: .error)
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
