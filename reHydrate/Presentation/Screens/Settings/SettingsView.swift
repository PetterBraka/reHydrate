//
//  SettingsView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    enum Field: Hashable {
        case small
        case medium
        case large
    }
    enum SheetType {
        case editIcon
        case credits
    }

    @FocusState private var focusedField: Field?
    @State private var showSheet: SheetType?

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    // TODO: add navigation back
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
            .sheet(item: $showSheet) { sheet in
                switch sheet {
                case .editIcon:
                    AppIconSelectionView {
                        showSheet = nil
                    }
                case .credits:
                    CreditsView {
                        showSheet = nil
                    }
                }
            }
            .alert(String(localized: "ui.settings.notifications.alert",
                          defaultValue: "Not allowed to send notifications",
                          comment: "An alert message displayed when the " +
                          "app isn't allowed to send notifications."),
                   isPresented: $viewModel.showNotificationAlert) {
                Button(String(localized: "ui.settings.cancel.button",
                              defaultValue: "Cancel",
                              comment: "An button to dismiss a alert."),
                       role: .cancel) {}
                Button(String(localized: "ui.settings.openSettings.button",
                              defaultValue: "Open settings",
                              comment: "A button to got to the settings app.")) {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { success in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
            }
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
                // - MARK: Edit drinks
                editDrinks
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
            CheckBoxButton(isChecked: $viewModel.isDarkModeOn,
                           text: String(localized: "ui.settings.appearance.lightMode",
                                        defaultValue: "Light mode"),
                           highlightedText: String(localized: "ui.settings.appearance.darkMode",
                                                   defaultValue: "Dark mode"),
                           image: .lightMode,
                           highlightedImage: .darkMode,
                           language: viewModel.language) {
                viewModel.isDarkModeOn.toggle()
            }
            Button {
                viewModel.showSheet = .editIcon
            } label: {
                HStack {
                    Text(String(localized: "ui.settings.appearance.changeAppIcon",
                                defaultValue: "Change app icon")
                    Spacer()
                    Image.open
                }
            }
            OptionsButton(title: String(localized: "ui.settings.appearance.language",
                                        defaultValue: "Language"),
                          selectedItem: $viewModel.selectedLanguage,
                          items: viewModel.languageOptions)
        }
    }
    
    @ViewBuilder
    var editGoal: some View {
        Section {
            HStack {
                Text(String(localized: "ui.settings.editGoal.setGoal",
                            defaultValue: "Set your goal")))
                Spacer()
                StepperView(value: viewModel.selectedGoal) {
                    viewModel.incrementGoal()
                } onDecrement: {
                    viewModel.decrementGoal()
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
                Picker("", selection: $viewModel.selectedUnit) {
                    Text(String(localized: "ui.settings.units.metric",
                                defaultValue: "Metric",
                                comment: ""))
                        .tag("metric")
                    Text(String(localized: "ui.settings.units.imperial",
                                defaultValue: "Imperial",
                                comment: ""))
                        .tag("imperial")
                }
                .pickerStyle(.segmented)
                .fixedSize()
            }
        }
    }
    
    @ViewBuilder
    var editDrinks: some View {
        Section {
            EditDrinksSectionView(focusedField: _focusedField,
                                  small: $viewModel.small,
                                  medium: $viewModel.medium,
                                  large: $viewModel.large,
                                  unit: $viewModel.unit,
                                  language: viewModel.language)
        }
    }
    
    @ViewBuilder
    var notifications: some View {
        Section {
            CheckBoxButton(isChecked: $viewModel.selectedRemindersOn,
                           text: String(localized: "ui.settings.notification.turnOn",
                                        defaultValue: "Turn on reminders"),
                           highlightedText: String(localized: "ui.settings.notification.turnOff",
                                                   defaultValue: "Turn off reminders"),
                           image: .remindersOff,
                           highlightedImage: .remindersOn,
                           language: viewModel.language) {
                if viewModel.remindersPremitted {
                    viewModel.toggleReminders()
                } else {
                    viewModel.showNotificationAlert.toggle()
                }
            }
            if viewModel.selectedRemindersOn {
                HStack {
                    DatePicker(String(localized: "ui.settings.notification.startingTime",
                                      defaultValue: "Starting time"),
                               selection: $viewModel.selectedStartDate,
                               in: viewModel.remindersStartRange,
                               displayedComponents: .hourAndMinute)
                }
                HStack {
                    DatePicker(String(localized: "ui.settings.notification.endingTime",
                                      defaultValue: "Ending time"),
                               selection: $viewModel.selectedEndDate,
                               in: viewModel.remindersEndRange,
                               displayedComponents: .hourAndMinute)
                }
                HStack {
                    Text(String(localized: "ui.settings.notification.frequency",
                                defaultValue: "Frequency"))
                    Spacer()
                    StepperView(value: viewModel.getFrequency()) {
                        viewModel.updateFrequency(shouldIncrese: true)
                    } onDecrement: {
                        viewModel.updateFrequency(shouldIncrese: false)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var credits: some View {
        Section {
            Button {
                viewModel.showSheet = .credits
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
                openLink(to: .contactMe)
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
                openLink(to: .privacy)
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
                openLink(to: .devInsta)
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
                         "\(viewModel.appVersion ?? "1.0.0")")
                }
                .font(.brandBody)
                .foregroundColor(Color.labelFaded)
                Spacer()
            }
        }
    }
}
