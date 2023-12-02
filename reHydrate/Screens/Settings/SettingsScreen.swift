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

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                toolbar
                list
                .font(.brandBody)
            }
            .foregroundColor(.label)
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(LocalizedString("ui.done.button",
                                                 value: "done",
                                                 comment: "An button to dismiss a the keyboard.")) {
                            focusedField = nil
                        }
                    }
                }
            })
            if observer.viewModel.isLoading {
                loading
            }
        }
        .transaction { $0.animation = .easeInOut }
        .alert(isPresented: Binding { observer.alert != nil } set: { _ in },
               error: observer.alert) { error in
            switch error {
            case .somethingWentWrong, .invalidFrequency, .cantOpenUrl:
                Button(LocalizedString(
                    "ui.generic.alert.action.done",
                    value: "Done",
                    comment: ""
                )) {
                    observer.perform(action: .dismissAlert)
                }
            case .unauthorizedAccessOfNotifications:
                Button(LocalizedString(
                    "ui.settings.alert.action.openSettings",
                    value: "Open settings",
                    comment: "An button which opens the app settings"
                )) {
                    observer.perform(action: .didOpenSettings)
                }
                Button(LocalizedString(
                    "ui.generic.alert.action.close",
                    value: "Close",
                    comment: ""
                ), role: .cancel) {
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
                    Text("Back")
                }
            }
            .foregroundColor(.button)
            .padding(.leading, 24)
        }
    }
    
    @ViewBuilder
    var loading: some View {
        ProgressView {
            Text(LocalizedString(
                "ui.loading",
                value: "Loading...",
                comment: "Text displayed with a loading wheel when we are loading data"
            ))
        }
        .padding(16)
        .background(in: .rect(cornerRadius: 16))
    }
    
    @ViewBuilder
    var list: some View {
        List {
            Group {
                appearance
                // - MARK: Units
                units
                // - MARK: Goal
                editGoal
                // - MARK: Notifications
                notifications
                // - MARK: Credits
                credits
                // - MARK: About app
                aboutApp
                // - MARK: Support dev
                supportDev
            }
            .listRowBackground(Color.tableViewBackground)
                // - MARK: App info
            appInfo
                .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    var appearance: some View {
        Section {
            CheckBoxButton(
                isChecked: Binding {
                    observer.viewModel.isDarkModeOn
                } set: { newValue in
                    observer.perform(action: .didSetDarkMode(newValue))
                },
                text: LocalizedString("ui.settings.appearance.lightMode",
                                        value: "Light mode",
                                        comment: "The light them of the app"),
                highlightedText: LocalizedString("ui.settings.appearance.darkMode",
                                                   value: "Dark mode",
                                                   comment: "The dark theme of the app"),
                image: .lightMode,
                highlightedImage: .darkMode)
            Button {
                observer.perform(action: .didTapEditAppIcon)
            } label: {
                HStack {
                    Text(LocalizedString("ui.settings.appearance.changeAppIcon",
                                           value: "Change app icon",
                                           comment: "Allows the user to change the apps icon on their device"))
                    Spacer()
                    Image.open
                }
            }
        }
    }
    
    @ViewBuilder
    var editGoal: some View {
        Section {
            HStack {
                Text(LocalizedString("ui.settings.editGoal.setGoal",
                                       value: "Set your goal",
                                       comment: "Set the users consumption goal"))
                Spacer()
                StepperView(value: observer.viewModel.goal.clean) {
                    observer.perform(action: .didTapIncrementGoal)
                } onDecrement: {
                    observer.perform(action: .didTapDecrementGoal)
                }
            }
        }
    }
    
    @ViewBuilder
    var units: some View {
        Section {
            HStack {
                Text(LocalizedString("ui.settings.units.title",
                                       value: "Units",
                                       comment: "The unit system used in the app"))
                Spacer()
                Picker("", selection: Binding(
                    get: { observer.viewModel.unitSystem },
                    set: { observer.perform(action: .didSetUnitSystem($0)) })
                ) {
                    Text(LocalizedString("ui.settings.units.metric",
                                           value: "Metric",
                                           comment: "The metric unit system"))
                    .tag(SettingsScreenObservable.ViewModel.UnitSystem.metric)
                    Text(LocalizedString("ui.settings.units.imperial",
                                           value: "Imperial",
                                           comment: "The imperial/british unit system"))
                    .tag(SettingsScreenObservable.ViewModel.UnitSystem.imperial)
                }
                .pickerStyle(.segmented)
                .fixedSize()
            }
        }
    }
    
    @ViewBuilder
    var notifications: some View {
        Section {
            CheckBoxButton(
                isChecked: Binding {
                    observer.viewModel.notifications.isOn
                } set: {
                    observer.perform(action: .didSetReminders($0))
                },
                text: LocalizedString("ui.settings.notification.turnOn",
                                        value: "Turn on reminders",
                                        comment: "Allows the user to turn on reminders to drink water"),
                highlightedText: LocalizedString("ui.settings.notification.turnOff",
                                                   value: "Turn off reminders",
                                                   comment: "Allows the user to turn off reminders to drink water"),
                image: .remindersOff,
                highlightedImage: .remindersOn)
            if observer.viewModel.notifications.isOn {
                HStack {
                    let date: Binding<Date> = Binding {
                        observer.viewModel.notifications.start
                    } set: {
                        observer.perform(action: .didSetRemindersStart($0))
                    }
                    DatePicker(LocalizedString("ui.settings.notification.startingTime",
                                                 value: "Starting time",
                                                 comment: "The starting time of the reminders"),
                               selection: date,
                               in: observer.viewModel.notifications.startRange,
                               displayedComponents: .hourAndMinute)
                }
                HStack {
                    let date: Binding<Date> = Binding {
                        observer.viewModel.notifications.stop
                    } set: {
                        observer.perform(action: .didSetRemindersStop($0))
                    }
                    DatePicker(
                        LocalizedString("ui.settings.notification.endingTime",
                                          value: "Ending time",
                                          comment: "The ending time of the reminders"),
                        selection: date,
                        in: observer.viewModel.notifications.stopRange,
                        displayedComponents: .hourAndMinute)
                }
                HStack {
                    Text(LocalizedString("ui.settings.notification.frequency",
                                           value: "Frequency",
                                           comment: "The frequency of the reminders in minutes"))
                    Spacer()
                    StepperView(value: "\(observer.viewModel.notifications.frequency)") {
                        observer.perform(action: .didTapIncrementFrequency)
                    } onDecrement: {
                        observer.perform(action: .didTapDecrementFrequency)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var credits: some View {
        Section {
            Button {
                observer.perform(action: .didTapCredits)
            } label: {
                HStack {
                    Text(LocalizedString("ui.settings.credits",
                                           value: "Credits",
                                           comment: "Who has help with the creation and translation of the app"))
                    Spacer()
                    Image.open
                }
            }
        }
    }
    
    @ViewBuilder
    var aboutApp: some View {
        Section {
            Button {
                observer.perform(action: .didTapContactMe)
            } label: {
                HStack {
                    Text(LocalizedString("ui.settings.aboutApp.contactUs",
                                           value: "Contact me",
                                           comment: "Our contact options"))
                    Spacer()
                    Image.open
                }
                .contentShape(Rectangle())
            }
            Button {
                observer.perform(action: .didTapPrivacy)
            } label: {
                HStack {
                    Text(LocalizedString("ui.settings.aboutApp.privacyPolicy",
                                           value: "Privacy policy",
                                           comment: "Our privacy policy"))
                    Spacer()
                    Image.open
                }
                .contentShape(Rectangle())
            }
            Button {
                observer.perform(action: .didTapDeveloperInstagram)
            } label: {
                HStack {
                    Text(LocalizedString("ui.settings.aboutApp.developerInstagram",
                                           value: "Developer Instagram",
                                           comment: "The developers instagram"))
                    Spacer()
                    Image.open
                }
                .contentShape(Rectangle())
            }
        }
    }
    
    @ViewBuilder
    var supportDev: some View {
        Section {
            Button {
                observer.perform(action: .didTapMerchandise)
            } label: {
                HStack {
                    Text(LocalizedString("ui.settings.aboutApp.metch",
                                           value: "Interested in merch?",
                                           comment: "Asks the user if they are interested in buying app merchandise"))
                    Spacer()
                    Image.open
                }
                .contentShape(Rectangle())
            }
        }
    }
    
    @ViewBuilder
    var appInfo: some View {
        Section {
            HStack {
                Spacer()
                VStack {
                    Text("reHydrate")
                    Text(LocalizedString("ui.settings.aboutApp.appInfo",
                                           value: "Version:",
                                           comment: "The version of the app") 
                         + "\(observer.viewModel.appVersion)")
                }
                .font(.brandBody)
                .foregroundColor(Color.labelFaded)
                Spacer()
            }
        }
    }
}

#Preview {
    SceneFactory.shared.makeSettingsScreen()
}
