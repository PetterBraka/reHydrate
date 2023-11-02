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
import PortsInterface

extension Screen.Settings {
    public final class Presenter: SettingsPresenterType {
        public typealias Engine = (
            HasLoggingService &
            HasDayService &
            HasDrinksService &
            HasUnitService &
            HasNotificationService &
            HasOpenUrlService &
            HasAppInfo
        )
        public typealias Router = (
            SettingsRoutable
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
                appVersion: engine.appVersion,
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
                await increaseGoal()
            case .didTapDecrementGoal:
                await decreaseGoal()
            case let .didSetUnitSystem(system):
                engine.unitService.set(unitSystem: .init(from: system))
                await updateViewModel(isLoading: false, unitSystem: system)
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
                await updateViewModel(isLoading: true)
                let frequency = viewModel.notifications.frequency - engine.notificationService.minimumAllowedFrequency
                await enableNotifications()
                await updateViewModel(isLoading: false, notifications: updatedNotificationsSettings(frequency: frequency))
            case .dismissAlert:
                await updateViewModel(isLoading: false, error: nil)
            case .didOpenSettings:
                await open(url: engine.openUrlService.settingsUrl)
            case .didTapPrivacy:
                await open(url: TrustedUrl.privacy.url)
            case .didTapDeveloperInstagram:
                await open(url: TrustedUrl.developerInstagram.url)
            case .didTapMerchandise:
                await open(url: TrustedUrl.merchandise.url)
            case .didTapContactMe:
                await email(
                    to: "Petter.braka+reHydrate@gmail.com",
                    cc: nil,
                    bcc: nil,
                    subject: "reHydrate query - v\(engine.appVersion)",
                    body: nil
                )
            case .didTapCredits:
                router.showCredits()
            case .didSetDarkMode(_), .didTapEditAppIcon:
                // TODO: Handle this properly
                await updateViewModel(isLoading: false, error: nil)
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
        var newGoal: Double
        if let goal {
            newGoal = goal
        } else {
            newGoal = await engine.dayService.getToday().goal
        }
        newGoal = engine.unitService.convert(newGoal, from: .litres,
                                             to: isMetric ? .litres : .pint)
        var drinks = await getDrinks()
        drinks = drinks.map { [weak self] drink in
            guard let self else { return drink }
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
            goal: newGoal,
            drinks: drinks,
            notifications: notifications,
            appVersion: engine.appVersion,
            error: error
        )
    }
}

// MARK: - Goal
extension Screen.Settings.Presenter {
    private func increaseGoal() async {
        do {
            let increment = 0.5
            let oldGoal = viewModel.goal
            let diffToNextHalf = oldGoal.roundToHalf(.up) - oldGoal
            let newGoal: Double
            if  diffToNextHalf > 0 && diffToNextHalf < increment {
                newGoal = try await engine.dayService.increase(goal: diffToNextHalf)
            } else {
                newGoal = try await engine.dayService.increase(goal: 0.5)
            }
            await updateViewModel(isLoading: false, goal: newGoal.roundToHalf(.up))
        } catch {
            engine.logger.error("Couldn't increase the goal", error: error)
        }
    }
    
    private func decreaseGoal() async {
        do {
            let decrement = 0.5
            let oldGoal = viewModel.goal
            let diffToNextHalf = oldGoal - oldGoal.roundToHalf(.down)
            let newGoal: Double
            if diffToNextHalf > 0 && diffToNextHalf < decrement {
                newGoal = try await engine.dayService.decrease(goal: diffToNextHalf)
            } else {
                newGoal = try await engine.dayService.decrease(goal: decrement)
            }
            await updateViewModel(isLoading: false, goal: newGoal.roundToHalf(.down))
        } catch {
            engine.logger.error("Couldn't decrease the goal", error: error)
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

extension Double {
    mutating func roundedToHalf(_ rule: FloatingPointRoundingRule = .toNearestOrEven) {
        self = self.roundToHalf(rule)
    }
    
    func roundToHalf(_ rule: FloatingPointRoundingRule = .toNearestOrEven) -> Double {
        (self * 2).rounded(rule) / 2
    }
}

extension Screen.Settings.Presenter {
    func open(url: URL?) async {
        await updateViewModel(isLoading: true, error: nil)
        do {
            guard let url else {
                throw OpenUrlError.invalidUrl("Missing")
            }
            try await engine.openUrlService.open(url: url)
            await updateViewModel(isLoading: false, error: nil)
        } catch {
            engine.logger.error("Couldn't open url", error: error)
            await updateViewModel(isLoading: false, error: .init(from: error as? OpenUrlError))
        }
    }
    
    func email(to email: String, cc: String?, bcc: String?,
               subject: String, body: String?) async {
        await updateViewModel(isLoading: true, error: nil)
        do {
            try await engine.openUrlService.email(
                to: email,
                cc: cc,
                bcc: bcc,
                subject: subject,
                body: body
            )
            await updateViewModel(isLoading: false, error: nil)
        } catch {
            engine.logger.error("Couldn't open url", error: error)
            await updateViewModel(isLoading: false, error: .init(from: error as? OpenUrlError))
        }
    }
}

extension Screen.Settings.Presenter.ViewModel.Error {
    init(from error: OpenUrlError?) {
        switch error {
        case .invalidUrl:
            self = .cantOpenUrl
        case .urlCantBeOpened:
            self = .cantOpenUrl
        case .none:
            self = .somethingWentWrong
        }
    }
}
