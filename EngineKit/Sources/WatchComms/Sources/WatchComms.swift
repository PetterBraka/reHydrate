//
//  WatchComms.swift
//
//
//  Created by Petter vang Brakalsvålet on 11/08/2024.
//

import Foundation
import LoggingService
import DateServiceInterface
import WatchCommsInterface
import DayServiceInterface
import DrinkServiceInterface
import UnitServiceInterface
import CommunicationKitInterface

public final class WatchComms {
    public typealias Engine = (
        HasLoggingService &
        HasDateService &
        HasDayService &
        HasDrinksService &
        HasUnitService &
        HasWatchService
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

extension WatchComms: WatchCommsType {
    public func setAppContext() async {
        guard canSendData()
        else {
            engine.logger.warning("Couldn't send data", error: nil)
            return
        }
        
        let data = await getWatchData()
        await sendAppContext(data)
    }
    
    public func sendDataToPhone() async {
        guard canSendData()
        else {
            engine.logger.warning("Couldn't send data", error: nil)
            return
        }
        
        let data = await getWatchData()
        await sendMessage(data)
    }
    
    public func addObserver(using updateBlock: @escaping () -> Void) {
        self.updateBlock = updateBlock
    }
    
    public func removeObserver() {
        self.updateBlock = nil
    }
}

private extension WatchComms {
    func canSendData() -> Bool {
        engine.watchService.isSupported() &&
        engine.watchService.currentState == .activated
    }
    
    func getWatchData() async -> [CommunicationUserInfo: Codable] {
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
        engine.watchService.sendMessage(data) { [weak self] error in
            self?.engine.logger.error("Failed sending \(data) to watchOS device", error: error)
        }
    }
    
    func sendAppContext(_ data: [CommunicationUserInfo: Codable]) async {
        do {
            try engine.watchService.update(applicationContext: data)
        } catch {
            engine.logger.error("Failed updating context \(data) to watchOS device", error: error)
        }
    }
}

private extension WatchComms {
    func addWatchObservers() {
        notificationCenter.addObserver(forName: .Shared.didReceiveApplicationContext,
                                       object: nil, queue: .main,
                                       using: process(notification:))
        notificationCenter.addObserver(forName: .Shared.didReceiveMessage,
                                       object: nil, queue: .main,
                                       using: process(notification:))
        notificationCenter.addObserver(forName: .Shared.didReceiveUserInfo,
                                       object: nil, queue: .main,
                                       using: process(notification:))
    }
    
    func removeWatchObservers() {
        notificationCenter.removeObserver(self, name: .Shared.didReceiveApplicationContext, object: nil)
        notificationCenter.removeObserver(self, name: .Shared.didReceiveMessage, object: nil)
        notificationCenter.removeObserver(self, name: .Shared.didReceiveUserInfo, object: nil)
    }
    
    func process(notification: Notification) {
        guard let watchData = notification.userInfo?.mapKeysAndValues() else { return }
        Task(priority: .high) { @MainActor in
            await process(day: watchData[.day])
            await process(drinks: watchData[.drinks])
            process(unitSystem: watchData[.unitSystem])
            
            updateBlock?()
        }
    }
    
    @MainActor
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
    
    @MainActor
    func process(drinks data: Data?) async {
        guard let data,
              let phoneDrinks = try? JSONDecoder().decode([Drink].self, from: data)
        else { return }
        
        let drinks = try? await engine.drinksService.getSaved()
        guard phoneDrinks != drinks else { return }
        
        for phoneDrink in phoneDrinks {
            if drinks?.contains(where: { $0.container == phoneDrink.container }) == true {
                do {
                    _ = try await engine.drinksService.edit(
                        size: phoneDrink.size,
                        of: phoneDrink.container
                    )
                } catch {
                    engine.logger.error("Failed to update drink to \(phoneDrink)", error: error)
                }
            } else {
                do {
                    _ = try await engine.drinksService.add(
                        size: phoneDrink.size,
                        container: phoneDrink.container
                    )
                } catch {
                    engine.logger.error("Failed to add drink to \(phoneDrink)", error: error)
                }
            }
        }
    }
    
    func process(unitSystem data: Data?) {
        guard let data,
              let phoneUnitSystem = try? JSONDecoder().decode(UnitSystem.self, from: data),
              phoneUnitSystem != engine.unitService.getUnitSystem()
        else { return }
        
        engine.unitService.set(unitSystem: phoneUnitSystem)
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
