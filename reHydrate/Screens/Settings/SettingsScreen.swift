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
//            .alert(NSLocalizedString("ui.settings.notifications.alert",
//                                     value: "Not allowed to send notifications",
//                                     comment: "An alert message displayed when the app isn't allowed to send notifications."),
//                   isPresented: $observer.showNotificationAlert) {
//                Button(NSLocalizedString("ui.settings.cancel.button",
//                                         value: "Cancel",
//                                         comment: "An button to dismiss a alert."),
//                       role: .cancel) {}
//                Button(NSLocalizedString("ui.settings.openSettings.button",
//                                         value: "Open settings",
//                                         comment: "A button to got to the settings app.")) {
//                    observer.perform(action: .didTapOpenSettings)
//                }
//            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(NSLocalizedString("ui.done.button",
                                                 value: "done",
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
            CheckBoxButton(
                isChecked: Binding {
                    observer.isDarkMode
                } set: { newValue in
                    observer.perform(action: .didSetDarkMode(newValue))
                },
                text: NSLocalizedString("ui.settings.appearance.lightMode",
                                        value: "Light mode",
                                        comment: "The light them of the app"),
                highlightedText: NSLocalizedString("ui.settings.appearance.darkMode",
                                                   value: "Dark mode",
                                                   comment: "The dark theme of the app"),
                image: .lightMode,
                highlightedImage: .darkMode)
            Button {
                observer.perform(action: .didTapEditAppIcon)
            } label: {
                HStack {
                    Text(NSLocalizedString("ui.settings.appearance.changeAppIcon",
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
                Text(NSLocalizedString("ui.settings.editGoal.setGoal",
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
                Text(NSLocalizedString("ui.settings.units.title",
                                       value: "Units",
                                       comment: "The unit system used in the app"))
                Spacer()
                Picker("", selection: Binding(
                    get: { observer.viewModel.unitSystem },
                    set: { observer.perform(action: .didSetUnitSystem($0)) })
                ) {
                    Text(NSLocalizedString("ui.settings.units.metric",
                                           value: "Metric",
                                           comment: "The metric unit system"))
                    .tag(SettingsScreenObservable.ViewModel.UnitSystem.metric)
                    Text(NSLocalizedString("ui.settings.units.imperial",
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
                    observer.isRemindersOn
                } set: { newValue in
                    observer.perform(action: .didSetReminders(newValue))
                },
                text: NSLocalizedString("ui.settings.notification.turnOn",
                                        value: "Turn on reminders",
                                        comment: "Allows the user to turn on reminders to drink water"),
                highlightedText: NSLocalizedString("ui.settings.notification.turnOff",
                                                   value: "Turn off reminders",
                                                   comment: "Allows the user to turn off reminders to drink water"),
                image: .remindersOff,
                highlightedImage: .remindersOn)
            if observer.isRemindersOn {
                HStack {
                    DatePicker(NSLocalizedString("ui.settings.notification.startingTime",
                                                 value: "Starting time",
                                                 comment: "The starting time of the reminders"),
                               selection: $observer.remindersStart,
                               in: observer.remindersStartRange,
                               displayedComponents: .hourAndMinute)
                }
                HStack {
                    DatePicker(NSLocalizedString("ui.settings.notification.endingTime",
                                                 value: "Ending time",
                                                 comment: "The ending time of the reminders"),
                               selection: $observer.remindersEnd,
                               in: observer.remindersEndRange,
                               displayedComponents: .hourAndMinute)
                }
                HStack {
                    Text(NSLocalizedString("ui.settings.notification.frequency",
                                           value: "Frequency",
                                           comment: "The frequency of the reminders in minutes"))
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
                    Text(NSLocalizedString("ui.settings.credits",
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
                    Text(NSLocalizedString("ui.settings.aboutApp.contactUs",
                                           value: "Contact us",
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
                    Text(NSLocalizedString("ui.settings.aboutApp.privacyPolicy",
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
                    Text(NSLocalizedString("ui.settings.aboutApp.developerInstagram",
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
                openLink(to: .merch)
            } label: {
                HStack {
                    Text(NSLocalizedString("ui.settings.aboutApp.metch",
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
                    Text(NSLocalizedString("ui.settings.aboutApp.appInfo",
                                           value: "Version:",
                                           comment: "The version of the app") 
                         + "\(observer.appVersion ?? "1.0.0")")
                }
                .font(.brandBody)
                .foregroundColor(Color.labelFaded)
                Spacer()
            }
        }
    }
}
