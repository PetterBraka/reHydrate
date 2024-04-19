//
//  SettingsScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import DrinkServiceInterface
import SwiftUI
import PresentationKit
import EngineKit

struct SettingsScreen: View {
    @ObservedObject var observer: SettingsScreenObservable
    @FocusState private var focusedField: Container?
    
    let cellMinHight: CGFloat = 26
    let sectionSpacing: CGFloat = 10
    
    init(observer: SettingsScreenObservable) {
        self.observer = observer
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.font: UIFont.Theme.callout], for: .normal
        )
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                toolbar
                content
                    .font(.Theme.callout)
                    .foregroundColor(.primary)
            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(Localized.doneTitle) {
                            focusedField = nil
                        }
                    }
                }
            })
            if observer.viewModel.isLoading {
                ProgressView {
                    Text(Localized.loadingTitle)
                }
                .padding(16)
                .background(in: .rect(cornerRadius: 16))
            }
        }
        .transaction { $0.animation = .easeInOut }
        .alert(isPresented: Binding { observer.alert != nil } set: { _ in }, error: observer.alert) { error in
            switch error {
            case .somethingWentWrong, .invalidFrequency, .cantOpenUrl:
                Button(Localized.doneAlertTitle) {
                    observer.perform(action: .dismissAlert)
                }
            case .unauthorizedAccessOfNotifications:
                Button(Localized.openSettingsTitle) {
                    observer.perform(action: .didOpenSettings)
                }
                Button(Localized.closeAlertTitle, role: .cancel) {
                    observer.perform(action: .dismissAlert)
                }
            }
        } message: { error in
            Text(error.message)
        }
    }
    
    @ViewBuilder
    var toolbar: some View {
        CustomToolbar {
            Text("")
        } leadingButton: {
            Button {
                observer.perform(action: .didTapBack)
            } label: {
                HStack {
                    Image.back
                    Text(Localized.backTitle)
                }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                Group {
                    appearance
                    units
                    editGoal
                    notifications
                    aboutApp
                    aboutDev
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.quinary)
                }
                appInfo
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
    }
    
    @ViewBuilder
    var appearance: some View {
        VStack(spacing: sectionSpacing) {
            CheckBoxButton(
                isChecked: Binding {
                    observer.viewModel.isDarkModeOn
                } set: { newValue in
                    withAnimation {
                        observer.perform(action: .didSetDarkMode(newValue))
                    }
                },
                text: Localized.lightModeTitle,
                highlightedText: Localized.darkModeTitle,
                image: .lightMode,
                highlightedImage: .darkMode)
            cellRow(title: Localized.changeAppIconTitle) {
                observer.perform(action: .didTapEditAppIcon)
            }
        }
    }
    
    @ViewBuilder
    var editGoal: some View {
        VStack(spacing: sectionSpacing) {
            HStack {
                Text(Localized.goalTitle)
                Spacer()
                StepperView(value: observer.viewModel.goal.clean) {
                    print("didTapIncrementGoal")
                    observer.perform(action: .didTapIncrementGoal)
                } onDecrement: {
                    print("didTapDecrementGoal")
                    observer.perform(action: .didTapDecrementGoal)
                }
            }
        }
    }
    
    @ViewBuilder
    var units: some View {
        VStack(spacing: sectionSpacing) {
            HStack {
                Text(Localized.unitsTitle)
                Spacer()
                Picker("", selection: Binding(
                    get: { observer.viewModel.unitSystem },
                    set: { observer.perform(action: .didSetUnitSystem($0)) })
                ) {
                    Text(Localized.metricTitle)
                    .tag(SettingsScreenObservable.ViewModel.UnitSystem.metric)
                    Text(Localized.imperialTitle)
                    .tag(SettingsScreenObservable.ViewModel.UnitSystem.imperial)
                }
                .pickerStyle(.segmented)
                .fixedSize()
            }
        }
    }
    
    @ViewBuilder
    var notifications: some View {
        VStack(spacing: sectionSpacing) {
            CheckBoxButton(
                isChecked: Binding {
                    observer.viewModel.notifications != nil
                } set: { value in
                    withAnimation {
                        observer.perform(action: .didSetReminders(value))
                    }
                },
                text: Localized.remindersOnTitle,
                highlightedText: Localized.remindersOffTitle,
                image: .remindersOff,
                highlightedImage: .remindersOn
            )
            if let notifications = observer.viewModel.notifications {
                DatePicker(
                    Localized.startingTimeTitle,
                    selection: Binding {
                        notifications.start
                    } set: {
                        observer.perform(action: .didSetRemindersStart($0))
                    },
                    in: notifications.startRange,
                    displayedComponents: .hourAndMinute
                )
                .transition(.move(edge: .top))
                DatePicker(
                    Localized.endingTimeTitle,
                    selection: Binding {
                        notifications.stop
                    } set: {
                        observer.perform(action: .didSetRemindersStop($0))
                    },
                    in: notifications.stopRange,
                    displayedComponents: .hourAndMinute
                )
                .transition(.move(edge: .top))
                HStack {
                    Text(Localized.frequencyTitle)
                    Spacer()
                    StepperView(value: "\(notifications.frequency)") {
                        observer.perform(action: .didTapIncrementFrequency)
                    } onDecrement: {
                        observer.perform(action: .didTapDecrementFrequency)
                    }
                }
                .transition(.move(edge: .top))
            }
        }
    }
    
    @ViewBuilder
    var aboutApp: some View {
        VStack(spacing: sectionSpacing) {
            cellRow(title: Localized.contactMeTitle) {
                observer.perform(action: .didTapContactMe)
            }
            cellRow(title: Localized.privacyPolicyTitle) {
                observer.perform(action: .didTapPrivacy)
            }
        }
    }
    
    @ViewBuilder
    var aboutDev: some View {
        VStack(spacing: sectionSpacing) {
            cellRow(title: Localized.creditsTitle) {
                observer.perform(action: .didTapCredits)
            }
            cellRow(title: Localized.devInstagramTitle) {
                observer.perform(action: .didTapDeveloperInstagram)
            }
            cellRow(title: Localized.merchTitle) {
                observer.perform(action: .didTapMerchandise)
            }
        }
    }
    
    @ViewBuilder
    var appInfo: some View {
        HStack {
            Spacer()
            VStack {
                Text("reHydrate")
                Text(Localized.appVersionTitle(observer.viewModel.appVersion))
            }
            .opacity(0.5)
            Spacer()
        }
    }
    
    func cellRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image.open
            }
            .padding(.vertical, 4)
            .padding(.trailing, 8)
            .contentShape(Rectangle())
        }
    }
}

extension SettingsScreen {
    enum Localized {
        static let doneTitle = LocalizedString(
            "ui.done.button",
            value: "done",
            comment: "An button to dismiss a the keyboard."
        )
        
        static let doneAlertTitle = LocalizedString(
            "ui.generic.alert.action.done",
            value: "Done",
            comment: ""
        )
        
        static let openSettingsTitle = LocalizedString(
            "ui.settings.alert.action.openSettings",
            value: "Open settings",
            comment: "An button which opens the app settings"
        )
        
        static let closeAlertTitle = LocalizedString(
            "ui.generic.alert.action.close",
            value: "Close",
            comment: ""
        )
        
        static let backTitle = LocalizedString(
            "ui.back",
            value: "Back",
            comment: "The back button in the navigation bar"
        )
        
        static let loadingTitle = LocalizedString(
            "ui.loading",
            value: "Loading...",
            comment: "Text displayed with a loading wheel when we are loading data"
        )
        
        static let lightModeTitle = LocalizedString(
            "ui.settings.appearance.lightMode",
            value: "Light mode",
            comment: "The light them of the app"
        )
        
        static let darkModeTitle = LocalizedString(
            "ui.settings.appearance.darkMode",
            value: "Dark mode",
            comment: "The dark theme of the app"
        )
        
        static let changeAppIconTitle = LocalizedString(
            "ui.settings.appearance.changeAppIcon",
            value: "Change app icon",
            comment: "Allows the user to change the apps icon on their device"
        )
        
        static let goalTitle = LocalizedString(
            "ui.settings.editGoal.setGoal",
            value: "Set your goal",
            comment: "Set the users consumption goal"
        )
        
        static let unitsTitle = LocalizedString(
            "ui.settings.units.title",
            value: "Units",
            comment: "The unit system used in the app"
        )
        
        static let metricTitle = LocalizedString(
            "ui.settings.units.metric",
            value: "Metric",
            comment: "The metric unit system"
        )
        
        static let imperialTitle = LocalizedString(
            "ui.settings.units.imperial",
            value: "Imperial",
            comment: "The imperial/british unit system"
        )
        
        static let remindersOnTitle = LocalizedString(
            "ui.settings.notification.turnOn",
            value: "Turn on reminders",
            comment: "Allows the user to turn on reminders to drink water"
        )
        
        static let remindersOffTitle = LocalizedString(
            "ui.settings.notification.turnOff",
            value: "Turn off reminders",
            comment: "Allows the user to turn off reminders to drink water"
        )
        
        static let startingTimeTitle = LocalizedString(
            "ui.settings.notification.startingTime",
            value: "Starting time",
            comment: "The starting time of the reminders"
        )
        
        static let endingTimeTitle = LocalizedString(
            "ui.settings.notification.endingTime",
            value: "Ending time",
            comment: "The ending time of the reminders"
        )
        
        static let frequencyTitle = LocalizedString(
            "ui.settings.notification.frequency",
            value: "Frequency",
            comment: "The frequency of the reminders in minutes"
        )
        
        static let creditsTitle = LocalizedString(
            "ui.settings.credits",
            value: "Credits",
            comment: "Who has help with the creation and translation of the app"
        )
        
        static let contactMeTitle = LocalizedString(
            "ui.settings.aboutApp.contactUs",
            value: "Contact me",
            comment: "Our contact options"
        )
        
        static let privacyPolicyTitle = LocalizedString(
            "ui.settings.aboutApp.privacyPolicy",
            value: "Privacy policy",
            comment: "Our privacy policy"
        )
        
        static let devInstagramTitle = LocalizedString(
            "ui.settings.aboutApp.developerInstagram",
            value: "Developer Instagram",
            comment: "The developers instagram"
        )
        
        static let merchTitle = LocalizedString(
            "ui.settings.aboutApp.metch",
            value: "Interested in merch?",
            comment: "Asks the user if they are interested in buying app merchandise"
        )
        
        static func appVersionTitle(_ appVersion: String) -> String {
            LocalizedString(
                "ui.settings.aboutApp.appInfo",
                value: "Version: %@",
                arguments: appVersion,
                comment: "The version of the app"
            )
        }
    }
}

#Preview {
    SceneFactory.shared.makeSettingsScreen()
}
