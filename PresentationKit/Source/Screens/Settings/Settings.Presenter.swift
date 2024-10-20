//
//  Screen.Settings.Presenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import Foundation
import LoggingService
import PresentationInterface
import UnitServiceInterface
import DayServiceInterface
import UserNotificationServiceInterface
import PortsInterface
import AppearanceServiceInterface
import DateServiceInterface
import PhoneCommsInterface

extension Screen.Settings {
    public final class Presenter: SettingsPresenterType {
        public typealias Engine = (
            HasLoggerService &
            HasDayService &
            HasUnitService &
            HasUserNotificationService &
            HasOpenUrlService &
            HasAppInfo &
            HasAppearanceService &
            HasDateService &
            HasPhoneComms
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
            
            viewModel = .init(
                isLoading: true,
                isDarkModeOn: engine.appearanceService.getAppearance() == .dark,
                unitSystem: .metric,
                goal: 0,
                notifications: nil,
                appVersion: engine.appVersion,
                error: nil
            )
        }
        
        @MainActor
        public func perform(action: Settings.Action) async {
            switch action {
            case .didAppear:
                await didAppear()
            case .didTapBack:
                router.showHome()
            case .didTapCredits:
                router.showCredits()
            case .didTapEditAppIcon:
                router.showAppIcon()
            case .didTapIncrementGoal:
                await increaseGoal()
                await engine.phoneComms.sendDataToWatch()
            case .didTapDecrementGoal:
                await decreaseGoal()
                await engine.phoneComms.sendDataToWatch()
            case let .didSetUnitSystem(system):
                await setUnitSystem(to: system)
                await engine.phoneComms.sendDataToWatch()
            case .didSetReminders(let shouldEnable):
                await updateViewModel(isLoading: true)
                if shouldEnable {
                   await enableNotifications()
                } else {
                    await disableNotifications()
                }
            case let .didSetRemindersStart(start):
                await updateViewModel(isLoading: true, notifications: getNotificationsSettings(start: start))
                await enableNotifications(start: start)
                await updateViewModel(isLoading: false)
            case let .didSetRemindersStop(stop):
                await updateViewModel(isLoading: true, notifications: getNotificationsSettings(stop: stop))
                await enableNotifications(stop: stop)
                await updateViewModel(isLoading: false)
            case .didTapIncrementFrequency:
                await increaseFrequency()
            case .didTapDecrementFrequency:
                await decreaseFrequency()
            case .dismissAlert:
                let frequency = engine.userNotificationService.minimumAllowedFrequency
                await updateViewModel(
                    isLoading: false,
                    notifications: getNotificationsSettings(frequency: frequency),
                    error: nil
                )
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
            case let .didSetDarkMode(isDarkModeOn):
                engine.appearanceService.setAppearance(isDarkModeOn ? .dark : .light)
                await updateViewModel(isLoading: false, isDarkModeOn: isDarkModeOn, error: nil)
            }
        }
        
        private func didAppear() async {
            let currentSystem = engine.unitService.getUnitSystem()
            let goal = await engine.dayService.getToday().goal
            
            await updateViewModel(
                isLoading: false,
                unitSystem: .init(from: currentSystem),
                goal: goal,
                error: nil
            )
            
            guard engine.userNotificationService.getSettings().isOn
            else {
                await updateViewModel(isLoading: false, notifications: nil, error: nil)
                return
            }
            
            let notificationSettings = getNotificationsSettings()
            
            await updateViewModel(
                isLoading: false,
                notifications: .init(
                    frequency: notificationSettings.frequency,
                    start: notificationSettings.start,
                    stop: notificationSettings.stop
                ),
                error: nil
            )
        }
        
    }
}

extension Screen.Settings.Presenter {
    private func updateViewModel(
        isLoading: Bool,
        isDarkModeOn: Bool? = nil,
        unitSystem: Settings.ViewModel.UnitSystem? = nil,
        goal: Double? = nil,
        error: Settings.ViewModel.Error? = nil
    ) async {
        viewModel = ViewModel(
            isLoading: isLoading,
            isDarkModeOn: isDarkModeOn ?? viewModel.isDarkModeOn,
            unitSystem: unitSystem ?? viewModel.unitSystem,
            goal: goal ?? viewModel.goal,
            notifications: viewModel.notifications,
            appVersion: engine.appVersion,
            error: error
        )
    }
    
    private func updateViewModel(
        isLoading: Bool,
        notifications: Settings.ViewModel.NotificationSettings?,
        error: Settings.ViewModel.Error? = nil
    ) async {
        viewModel = ViewModel(
            isLoading: isLoading,
            isDarkModeOn: viewModel.isDarkModeOn,
            unitSystem: viewModel.unitSystem,
            goal: viewModel.goal,
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
            let currentGoal = viewModel.goal
            let diffToNextHalf = currentGoal.roundToHalf(.up) - currentGoal
            let newGoal = if diffToNextHalf > 0 {
                try await engine.dayService.increase(goal: diffToNextHalf)
            } else {
                try await engine.dayService.increase(goal: increment)
            }
            
            await updateViewModel(isLoading: false, goal: newGoal)
        } catch {
            engine.logger.log(
                category: .presentationKit,
                message: "Couldn't increase the goal",
                error: error,
                level: .error
            )
        }
    }
    
    private func decreaseGoal() async {
        do {
            let decrement = 0.5
            let oldGoal = viewModel.goal
            let diffToNextHalf = oldGoal - oldGoal.roundToHalf(.down)
            let newGoal = if diffToNextHalf > 0 {
                try await engine.dayService.decrease(goal: diffToNextHalf)
            } else {
                try await engine.dayService.decrease(goal: decrement)
            }
            
            await updateViewModel(isLoading: false, goal: newGoal)
        } catch {
            engine.logger.log(
                category: .presentationKit,
                message: "Couldn't decrease the goal",
                error: error,
                level: .error
            )
        }
    }
}

// MARK: - Units
extension Screen.Settings.Presenter {
    func setUnitSystem(to newSystem: Settings.ViewModel.UnitSystem) async {
        engine.unitService.set(unitSystem: .init(from: newSystem))
        let previousUnit: UnitModel = viewModel.unitSystem == .metric ? .litres : .pint
        let newUnit: UnitModel = newSystem == .metric ? .litres : .pint
        let newGoal = engine.unitService.convert(viewModel.goal, from: previousUnit, to: newUnit)
        await updateViewModel(isLoading: false, unitSystem: newSystem, goal: newGoal)
    }
}

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

// MARK: - Notifications
private extension Screen.Settings.Presenter {
    func increaseFrequency() async {
        await updateViewModel(isLoading: true)
        let minFrequency = engine.userNotificationService.minimumAllowedFrequency
        let newFrequency: Int
        if let frequency = engine.userNotificationService.getSettings().frequency {
            newFrequency = frequency + minFrequency
        } else {
            newFrequency = minFrequency
        }
        let settings = getNotificationsSettings(frequency: newFrequency)
        await updateViewModel(isLoading: true, notifications: settings)
        await enableNotifications(frequency: newFrequency)
    }
    
    func decreaseFrequency() async {
        await updateViewModel(isLoading: true)
        let minFrequency = engine.userNotificationService.minimumAllowedFrequency
        let newFrequency: Int
        if let frequency = engine.userNotificationService.getSettings().frequency {
            newFrequency = frequency - minFrequency
        } else {
            newFrequency = minFrequency
        }
        let settings = getNotificationsSettings(frequency: newFrequency)
        await updateViewModel(isLoading: true, notifications: settings)
        await enableNotifications(frequency: newFrequency)
    }
    
    func enableNotifications(frequency: Int? = nil, start: Date? = nil, stop: Date? = nil) async {
        let settings = getNotificationsSettings(frequency: frequency, start: start, stop: stop)
        
        let result = await engine.userNotificationService.enable(
            withFrequency: settings.frequency,
            start: settings.start,
            stop: settings.stop
        )
        
        switch result {
        case .success:
            await updateViewModel(
                isLoading: false,
                notifications: .init(
                    frequency: settings.frequency,
                    start: settings.start,
                    stop: settings.stop
                )
            )
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
    
    func disableNotifications() async {
        engine.userNotificationService.disable()
        await updateViewModel(isLoading: false, notifications: nil)
    }
    
    func getNotificationsSettings(
        frequency: Int? = nil,
        start startDate: Date? = nil,
        stop stopDate: Date? = nil
    ) -> ViewModel.NotificationSettings {
        let notificationSettings = engine.userNotificationService.getSettings()
        
        let frequency = frequency ?? notificationSettings.frequency ?? engine.userNotificationService.minimumAllowedFrequency
        let now = engine.dateService.now()
        
        let start: Date =
        if let date = startDate ?? notificationSettings.start {
            date
        } else {
            engine.dateService.date(hours: 7, minutes: 00, seconds: 00, from: now) ??
            engine.dateService.getStart(of: now)
        }
        let stop: Date =
        if let date = stopDate ?? notificationSettings.stop {
            date
        } else {
            engine.dateService.date(hours: 21, minutes: 00, seconds: 00, from: now) ??
            engine.dateService.getEnd(of: now)
        }
        
        return .init(
            frequency: frequency,
            start: start,
            stop: stop
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
            engine.logger.log(
                category: .presentationKit,
                message: "Couldn't open url",
                error: error,
                level: .error
            )
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
            engine.logger.log(
                category: .presentationKit,
                message: "Couldn't open url",
                error: error,
                level: .error
            )
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
