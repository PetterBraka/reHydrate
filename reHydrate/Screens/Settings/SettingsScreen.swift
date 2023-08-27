//
//  SettingsScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import DrinkServiceInterface
import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var observer: SettingsScreenObservable
    @FocusState private var focusedField: Container?

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    observer.perform(action: .didTapBack)
                } label: {
                    Image.back
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.button)
                }
                .padding([.leading, .top], 24)
                .padding(.bottom, 16)
                list
                .font(.brandBody)
            }
            .foregroundColor(.label)
//            TODO: Sheets needs to be moved
//            .sheet(item: $showSheet) { sheet in
//                switch sheet {
//                case .editIcon:
//                    AppIconSelectionView {
//                        showSheet = nil
//                    }
//                case .credits:
//                    CreditsView {
//                        showSheet = nil
//                    }
//                }
//            }
//            TODO: Alert needs to be moved
//            .alert(String(localized: "ui.settings.notifications.alert",
//                          defaultValue: "Not allowed to send notifications",
//                          comment: "An alert message displayed when the app isn't allowed to send notifications."),
//                   isPresented: $observer.showNotificationAlert) {
//                Button(String(localized: "ui.settings.cancel.button",
//                              defaultValue: "Cancel",
//                              comment: "An button to dismiss a alert."),
//                       role: .cancel) {}
//                Button(String(localized: "ui.settings.openSettings.button",
//                              defaultValue: "Open settings",
//                              comment: "A button to got to the settings app.")) {
//                    observer.perform(action: .didTapOpenSettings)
//                }
//            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(String(localized: "ui.settings.done.button",
                                      defaultValue: "done",
                                      comment: "An button to dismiss a the keyboard.")) {
                            focusedField = nil
                        }
                    }
                }
            })
        }
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
                // - MARK: App info
                appInfo
            }
            .listRowBackground(Color.tableViewBackground)
        }
        .listStyle(.insetGrouped)
    }
    
    @ViewBuilder
    var appearance: some View {
        Section {
            CheckBoxButton(isChecked: $observer.isDarkMode,
                           text: String(localized: "ui.settings.appearance.lightMode",
                                        defaultValue: "Light mode"),
                           highlightedText: String(localized: "ui.settings.appearance.darkMode",
                                                   defaultValue: "Dark mode"),
                           image: .lightMode,
                           highlightedImage: .darkMode) {
                observer.perform(action: .didTapDarkModeToggle)
            }
            Button {
                observer.perform(action: .didTapEditAppIcon)
            } label: {
                HStack {
                    Text(String(localized: "ui.settings.appearance.changeAppIcon",
                                defaultValue: "Change app icon"))
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
                Text(String(localized: "ui.settings.editGoal.setGoal",
                            defaultValue: "Set your goal"))
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
                Text(String(localized: "ui.settings.units.title",
                            defaultValue: "Units",
                            comment: ""))
                Spacer()
                Picker("", selection: $observer.viewModel.unitSystem) {
                    Text(String(localized: "ui.settings.units.metric",
                                defaultValue: "Metric",
                                comment: ""))
                    .tag(SettingsScreenObservable.ViewModel.UnitSystem.metric)
                    Text(String(localized: "ui.settings.units.imperial",
                                defaultValue: "Imperial",
                                comment: ""))
                    .tag(SettingsScreenObservable.ViewModel.UnitSystem.imperial)
                }
                .pickerStyle(.segmented)
                .fixedSize()
                .onChange(of: observer.viewModel.unitSystem) { oldValue, newValue in
                    observer.perform(action: .didSetUnitSystem(newValue))
                }
            }
        }
    }
    
    @ViewBuilder
    var notifications: some View {
        Section {
            CheckBoxButton(isChecked: $observer.isRemindersOn,
                           text: String(localized: "ui.settings.notification.turnOn",
                                        defaultValue: "Turn on reminders"),
                           highlightedText: String(localized: "ui.settings.notification.turnOff",
                                                   defaultValue: "Turn off reminders"),
                           image: .remindersOff,
                           highlightedImage: .remindersOn) {
                observer.perform(action: .didTapRemindersToggle)
            }
            if observer.isRemindersOn {
                HStack {
                    DatePicker(String(localized: "ui.settings.notification.startingTime",
                                      defaultValue: "Starting time"),
                               selection: $observer.remindersStart,
                               in: observer.remindersStartRange,
                               displayedComponents: .hourAndMinute)
                }
                HStack {
                    DatePicker(String(localized: "ui.settings.notification.endingTime",
                                      defaultValue: "Ending time"),
                               selection: $observer.remindersEnd,
                               in: observer.remindersEndRange,
                               displayedComponents: .hourAndMinute)
                }
                HStack {
                    Text(String(localized: "ui.settings.notification.frequency",
                                defaultValue: "Frequency"))
                    Spacer()
                    StepperView(value: "\(observer.reminderFrequency)") {
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
                    Text(String(localized: "ui.settings.credits",
                                defaultValue: "Credits"))
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
                    Text(String(localized: "ui.settings.aboutApp.contactUs",
                                defaultValue: "Contact us"))
                    Spacer()
                    Image.open
                }
                .contentShape(Rectangle())
            }
            Button {
                observer.perform(action: .didTapPrivacy)
            } label: {
                HStack {
                    Text(String(localized: "ui.settings.aboutApp.privacyPolicy",
                                defaultValue: "Privacy policy"))
                    Spacer()
                    Image.open
                }
                .contentShape(Rectangle())
            }
            Button {
                observer.perform(action: .didTapDeveloperInstagram)
            } label: {
                HStack {
                    Text(String(localized: "ui.settings.aboutApp.developerInstagram",
                                defaultValue: "Developer Instagram"))
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
                openLink(to: .merch)
            } label: {
                HStack {
                    Text(String(localized: "ui.settings.aboutApp.metch",
                                defaultValue: "Interested in merch?"))
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
                    Text(String(localized: "ui.settings.aboutApp.appInfo",
                                defaultValue: "Version:") +
                         "\(observer.appVersion ?? "1.0.0")")
                }
                .font(.brandBody)
                .foregroundColor(Color.labelFaded)
                Spacer()
            }
        }
    }
}
