//
//  Screen.Settings.Presenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import Foundation
import LoggingService
import SettingsPresentationInterface
import UnitServiceInterface
import DayServiceInterface
import DrinkServiceInterface
import DatabaseServiceInterface
import NotificationServiceInterface

extension Screen.Settings {
    public final class Presenter: SettingsPresenterType {
        public typealias Engine = (
            HasLoggingService &
            HasDayService &
            HasDrinksService &
            HasUnitService &
            HasNotificationService
        )
        public typealias Router = (
            HomeRoutable
        )
        
        public typealias ViewModel = Settings.ViewModel
        
        private let engine: Engine
        private let router: Router
        
        public var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        public weak var scene: SettingsSceneType?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            let startOfDay = Date(time:"00:00")!
            let start = Date(time:"08:00")!
            let stop = Date(time:"20:00")!
            let endOfDay = Date(time:"23:59")!
            viewModel = .init(
                isLoading: false,
                unitSystem: .metric,
                goal: 0,
                drinks: [],
                notifications: .init(
                    isOn: false,
                    frequency: 30,
                    start: start,
                    startRange: startOfDay ... stop,
                    stop: Date(time: "20:00")!,
                    stopRange: start ... endOfDay
                ),
                error: nil
            )
            Task(priority: .high) {
                await initRealViewModel()
            }
        }
        
        private func initRealViewModel() async {
            let currentSystem = engine.unitService.getUnitSystem()
            let goal = await engine.dayService.getToday().goal
            let notificationServiceSettings = engine.notificationService.getSettings()
            await updateViewModel(
                isLoading: false,
                unitSystem: .init(from: currentSystem),
                goal: goal,
                notifications: updatedNotificationsSettings(
                    isOn: notificationServiceSettings.isOn,
                    frequency: notificationServiceSettings.frequency,
                    start: notificationServiceSettings.start,
                    stop: notificationServiceSettings.stop
                ),
                error: nil
            )
        }
        
        @MainActor
        public func perform(action: Settings.Action) async {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didTapIncrementGoal:
                increaseGoal()
            case .didTapDecrementGoal:
                decreaseGoal()
            case let .didSetUnitSystem(system):
                engine.unitService.set(unitSystem: .init(from: system))
                let updatedSystem = engine.unitService.getUnitSystem()
                await updateViewModel(isLoading: false, unitSystem: .init(from: updatedSystem))
            case .didSetReminders(let shouldEnable):
                await updateViewModel(isLoading: true)
                if shouldEnable {
                   await enableNotifications()
                } else {
                    await disableNotifications()
                }
            case let .didSetRemindersStart(start):
                await updateViewModel(isLoading: true)
                await enableNotifications()
                await updateViewModel(isLoading: false, notifications: updatedNotificationsSettings(start: start))
            case let .didSetRemindersStop(stop):
                await updateViewModel(isLoading: true)
                await enableNotifications()
                await updateViewModel(isLoading: false, notifications: updatedNotificationsSettings(stop: stop))
            case .didTapIncrementFrequency:
                let frequency = viewModel.notifications.frequency + engine.notificationService.minimumAllowedFrequency
                await updateViewModel(isLoading: false, notifications: updatedNotificationsSettings(frequency: frequency))
                await enableNotifications()
            case .didTapDecrementFrequency:
                let frequency = viewModel.notifications.frequency - engine.notificationService.minimumAllowedFrequency
                await updateViewModel(isLoading: false, notifications: updatedNotificationsSettings(frequency: frequency))
                await enableNotifications()
            default:
                // TODO: Fix this Petter
                break
            }
        }
    }
}

extension Screen.Settings.Presenter {
    private func getDrinks() async -> [ViewModel.Drink] {
        if let drinks = try? await engine.drinksService.getSaved(),
            !drinks.isEmpty {
            return drinks.map { .init(from: $0) }
        } else {
            let drinks = await engine.drinksService.resetToDefault()
            return drinks.map { .init(from: $0) }
        }
    }
    
    private func updateViewModel(
        isLoading: Bool,
        unitSystem: Settings.ViewModel.UnitSystem? = nil,
        goal: Double? = nil,
        notifications: Settings.ViewModel.NotificationSettings? = nil,
        error: Settings.ViewModel.Error? = nil
    ) async {
        let unitSystem = unitSystem ?? viewModel.unitSystem
        let isMetric = unitSystem == .metric
        var goal = goal ?? viewModel.goal
        goal = engine.unitService.convert(goal, from: .litres,
                                          to: isMetric ? .litres : .pint)
        var drinks = await getDrinks()
        drinks = drinks.map { drink in
            var drink = drink
            drink.size = engine.unitService.convert(drink.size,
                                                    from: .millilitres,
                                                    to: isMetric ? .millilitres : .ounces)
            return drink
        }
        
        let notifications = notifications ?? viewModel.notifications
        
        viewModel = ViewModel(
            isLoading: isLoading,
            unitSystem: unitSystem,
            goal: goal,
            drinks: drinks,
            notifications: notifications, 
            error: error
        )
    }
}

// MARK: - Goal
extension Screen.Settings.Presenter {
    private func increaseGoal() {
        Task {
            do {
                let currentSystem = engine.unitService.getUnitSystem()
                let newGoalRawValue = try await engine.dayService.increase(goal: 0.5)
                let newGoal = engine.unitService.convert(newGoalRawValue, from: .litres,
                                                         to: currentSystem == .metric ? .litres : .pint)
                await updateViewModel(isLoading: false, goal: newGoal)
            }
        }
    }
    
    private func decreaseGoal() {
        Task {
            do {
                let currentSystem = engine.unitService.getUnitSystem()
                let newGoalRawValue = try await engine.dayService.decrease(goal: 0.5)
                let newGoal = engine.unitService.convert(newGoalRawValue, from: .litres,
                                                         to: currentSystem == .metric ? .litres : .pint)
                await updateViewModel(isLoading: false, goal: newGoal)
            }
        }
    }
}

// MARK: - Units
extension Settings.ViewModel.UnitSystem {
    init(from system: UnitServiceInterface.UnitSystem) {
        switch system {
        case .imperial:
            self = .imperial
        case .metric:
            self = .metric
        }
    }
}

extension UnitSystem {
    init(from system: Settings.ViewModel.UnitSystem) {
        switch system {
        case .imperial:
            self = .imperial
        case .metric:
            self = .metric
        }
    }
}

// MARK: - Drink
extension Screen.Settings.Presenter.ViewModel.Drink {
    init(from drink: Drink) {
        self = .init(id: drink.id,
                     size: drink.size,
                     container: .init(from: drink.container))
    }
}

extension Screen.Settings.Presenter.ViewModel.Container {
    init(from container: Container) {
        switch container {
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        }
    }
}
// MARK: - Notifications
private extension Screen.Settings.Presenter {
    func enableNotifications() async {
        let result = await engine.notificationService.enable(
            withFrequency: viewModel.notifications.frequency,
            start: viewModel.notifications.start,
            stop: viewModel.notifications.stop
        )
        
        switch result {
        case .success:
            await updateViewModel(isLoading: false, notifications: updatedNotificationsSettings(isOn: true))
        case .failure(let error):
            switch error {
            case .unauthorized:
                await updateViewModel(isLoading: false, error: .unauthorized)
            case .invalidDate, .missingDateComponents:
                await updateViewModel(isLoading: false, error: .invalidDates)
            case .missingReminders, .missingCongratulations:
                await updateViewModel(isLoading: false, error: .missingReminders)
            case .frequencyTooLow:
                await updateViewModel(isLoading: false, error: .lowFrequency)
            case .alreadySet:
                // If the notifications are already set we don't need to do it again
                break
            }
        }
    }
    
    func getRanges(start: Date, stop: Date) -> (start: ClosedRange<Date>, stop: ClosedRange<Date>) {
        let calendar = Calendar.current
        let minimumAllowedFrequency = engine.notificationService.minimumAllowedFrequency
        guard let startRangeStart = Date(time: "00:00"),
              let startRangeEnd = calendar.date(byAdding: .minute, value: -minimumAllowedFrequency, to: stop),
              let stopRangeStart = calendar.date(byAdding: .minute, value: minimumAllowedFrequency, to: start),
              let stopRangeEnd = Date(time: "23:59")
        else {
            engine.logger.critical("Date formatter stoped working")
            fatalError("Date formatter stoped working")
        }
        
        return (startRangeStart ... startRangeEnd,
                stopRangeStart ... stopRangeEnd)
    }
    
    func disableNotifications() async {
        engine.notificationService.disable()
        await updateViewModel(isLoading: false, notifications: updatedNotificationsSettings(isOn: false))
    }
    
    func updatedNotificationsSettings(
        isOn: Bool? = nil,
        frequency: Int? = nil,
        start: Date? = nil,
        stop: Date? = nil
    ) -> ViewModel.NotificationSettings {
        let isOn = isOn ?? viewModel.notifications.isOn
        let frequency = frequency ?? viewModel.notifications.frequency
        let start = start ?? viewModel.notifications.start
        let stop = stop ?? viewModel.notifications.stop
        let range = getRanges(start: start, stop: stop)

        return .init(
            isOn: isOn,
            frequency: frequency,
            start: start,
            startRange: range.start,
            stop: stop,
            stopRange: range.stop
        )
    }
}

public extension Date {
    /// - Parameters:
    ///   - time: "HH:mm:ss"
    init?(time: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        
        let dateAndTime = "\(time) 24/10/2023"
        guard let date = formatter.date(from: dateAndTime)
        else { return nil }
        self = date
    }
}
