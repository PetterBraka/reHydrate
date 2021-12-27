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
        case goal
    }
    @StateObject var viewModel: SettingsViewModel
    @State var showIconSelection = false
    @FocusState private var focusedField: Field?

    init(navigateTo: @escaping ((AppState) -> Void)) {
        let viewModel = MainAssembler.shared.container.resolve(SettingsViewModel.self,
                                                               argument: navigateTo)!
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                    Button {
                        viewModel.navigateToHome()
                    } label: {
                        Image.back
                            .resizable()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.button)
                    }
                    .padding([.leading, .top], 24)
            Form {
                // Apperance
                Section {
                    CheckBoxButton(isChecked: $viewModel.isDarkMode,
                                   text: Localizable.Setting.lightMode,
                                   highlightedText: Localizable.Setting.darkMode,
                                   image: .lightMode,
                                   highlightedImage: .darkMode,
                                   language: $viewModel.language) {
                        viewModel.toggleDarkMode()
                    }
                    Button {
                        showIconSelection = true
                    } label: {
                        HStack {
                            Text(Localizable.Setting.appIcon.local(viewModel.language))
                            Spacer()
                            Image.open
                        }
                    }
                    .foregroundColor(.label)
                    OptionsButton(title: Localizable.Language.language,
                                  selectedItem: $viewModel.selectedLanguage,
                                  items: viewModel.languageOptions,
                                  language: $viewModel.language)
                }
                .listRowBackground(Color.tableViewBackground)
                // Units
                Section {
                    HStack {
                        Text(Localizable.Setting.units.local(viewModel.language))
                        Spacer()
                        Picker("", selection: $viewModel.selectedUnit) {
                            Text(Localizable.Setting.metricSystem.local(viewModel.language))
                                .tag(Localizable.Setting.metricSystem)
                            Text(Localizable.Setting.imperialSystem.local(viewModel.language))
                                .tag(Localizable.Setting.imperialSystem)
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                }
                .listRowBackground(Color.tableViewBackground)
                // Goal
                Section {
                    HStack {
                        Text(Localizable.Setting.setYourGoal.local(viewModel.language))
                        Spacer()
                        StepperView(value: viewModel.selectedGoal) {
                            viewModel.incrementGoal()
                        } onDecrement: {
                            viewModel.decrementGoal()
                        }
                    }
                }
                .listRowBackground(Color.tableViewBackground)
                // Notifications
                Section {
                    CheckBoxButton(isChecked: $viewModel.selectedRemindersOn,
                                   text: Localizable.Reminders.turnOnReminders,
                                   highlightedText: Localizable.Reminders.turnOffReminders,
                                   image: .remindersOff,
                                   highlightedImage: .remindersOn,
                                   language: $viewModel.language) {
                        if viewModel.remindersPremitted {
                            viewModel.toggleReminders()
                        } else {
                            viewModel.showNotificationAlert.toggle()
                        }
                    }
                    if viewModel.selectedRemindersOn {
                        HStack {
                            DatePicker(Localizable.Reminders.startingTime.local(viewModel.language),
                                       selection: $viewModel.selectedStartDate,
                                       displayedComponents: .hourAndMinute)
                        }
                        HStack {
                            DatePicker(Localizable.Reminders.endingTime.local(viewModel.language),
                                       selection: $viewModel.selectedEndDate,
                                       displayedComponents: .hourAndMinute)
                        }
                        HStack {
                            Text(Localizable.Reminders.frequency.local(viewModel.language))
                            Spacer()
                            StepperView(value: viewModel.getFrequency()) {
                                viewModel.incrementFrequency()
                            } onDecrement: {
                                viewModel.decrementFrequency()
                            }

                        }
                    }
                }
                .listRowBackground(Color.tableViewBackground)
            }
            .font(.body)
        }
            .sheet(isPresented: $showIconSelection) {
                AppIconSelectionView {
                    showIconSelection = false
                }
            }

            .alert(Localizable.Popup.RemindersNotAllowed.local(viewModel.language),
                   isPresented: $viewModel.showNotificationAlert) {
                Button(Localizable.cancel.local(viewModel.language), role: .cancel) {}
                Button(Localizable.Setting.openAppSettings.local(viewModel.language)) {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
            }
                   .toolbar(content: {
                       ToolbarItemGroup(placement: .keyboard) {
                           HStack {
                               Spacer()
                               Button(Localizable.done) {
                                   focusedField = nil
                               }
                           }
                       }
                   })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView {_ in}
    }
}