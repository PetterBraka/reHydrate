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
    @StateObject var viewModel: SettingsViewModel
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
                .padding(.bottom, 16)
                List {
                    // Apperance
                    Section {
                        CheckBoxButton(isChecked: $viewModel.isDarkMode,
                                       text: Localizable.lightMode,
                                       highlightedText: Localizable.darkMode,
                                       image: .lightMode,
                                       highlightedImage: .darkMode,
                                       language: $viewModel.language) {
                            viewModel.toggleDarkMode()
                        }
                        Button {
                            viewModel.showSheet = .editIcon
                        } label: {
                            HStack {
                                Text(Localizable.appIcon.local(viewModel.language))
                                Spacer()
                                Image.open
                            }
                        }
                        OptionsButton(title: Localizable.language,
                                      selectedItem: $viewModel.selectedLanguage,
                                      items: viewModel.languageOptions,
                                      language: $viewModel.language)
                    }
                    .listRowBackground(Color.tableViewBackground)
                    // Units
                    Section {
                        HStack {
                            Text(Localizable.units.local(viewModel.language))
                            Spacer()
                            Picker("", selection: $viewModel.selectedUnit) {
                                Text(Localizable.metricSystem.local(viewModel.language))
                                    .tag(Localizable.metricSystem)
                                Text(Localizable.imperialSystem.local(viewModel.language))
                                    .tag(Localizable.imperialSystem)
                            }
                            .pickerStyle(.segmented)
                            .fixedSize()
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    // Goal
                    Section {
                        HStack {
                            Text(Localizable.setYourGoal.local(viewModel.language))
                            Spacer()
                            StepperView(value: viewModel.selectedGoal) {
                                viewModel.incrementGoal()
                            } onDecrement: {
                                viewModel.decrementGoal()
                            }
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    // Drink size
                    Section {
                        EditDrinksSectionView(focusedField: _focusedField,
                                              small: $viewModel.small,
                                              medium: $viewModel.medium,
                                              large: $viewModel.large,
                                              unit: $viewModel.unit,
                                              language: viewModel.language)
                    }
                    .listRowBackground(Color.tableViewBackground)
                    // Notifications
                    Section {
                        CheckBoxButton(isChecked: $viewModel.selectedRemindersOn,
                                       text: Localizable.turnOnReminders,
                                       highlightedText: Localizable.turnOffReminders,
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
                                DatePicker(Localizable.startingTime.local(viewModel.language),
                                           selection: $viewModel.selectedStartDate,
                                           displayedComponents: .hourAndMinute)
                            }
                            HStack {
                                DatePicker(Localizable.endingTime.local(viewModel.language),
                                           selection: $viewModel.selectedEndDate,
                                           displayedComponents: .hourAndMinute)
                            }
                            HStack {
                                Text(Localizable.frequency.local(viewModel.language))
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
                    // Credits
                    Section {
                        Button {
                            viewModel.showSheet = .credits
                        } label: {
                            HStack {
                                Text(Localizable.credits.local(viewModel.language))
                                Spacer()
                                Image.open
                            }
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    // About app
                    Section {
                        Button {
                            openLink(to: .contactMe)
                        } label: {
                            HStack {
                                Text(Localizable.contactUs.local(viewModel.language))
                                Spacer()
                                Image.open
                            }
                            .contentShape(Rectangle())
                        }
                        Button {
                            openLink(to: .privacy)
                        } label: {
                            HStack {
                                Text(Localizable.privacyPolicy.local(viewModel.language))
                                Spacer()
                                Image.open
                            }
                            .contentShape(Rectangle())
                        }
                        Button {
                            openLink(to: .devInsta)
                        } label: {
                            HStack {
                                Text(Localizable.devInsta.local(viewModel.language))
                                Spacer()
                                Image.open
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    // Support dev
                    Section {
                        Button {
                            openLink(to: .merch)
                        } label: {
                            HStack {
                                Text(Localizable.merch.local(viewModel.language))
                                Spacer()
                                Image.open
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    // App info
                    Section {
                        HStack {
                        Spacer()
                            VStack {
                                Text("reHydrate")
                                Text("\(Localizable.versionNumber.local(viewModel.language)) " +
                                     "\(viewModel.appVersion ?? "1.0.0")")
                            }
                            .font(.body)
                            .foregroundColor(Color.labelFaded)
                        Spacer()
                    }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(InsetGroupedListStyle())
                .font(.body)
            }
            .foregroundColor(.label)
            .sheet(item: $viewModel.showSheet) { sheet in
                switch sheet {
                case .editIcon:
                    AppIconSelectionView {
                        viewModel.showSheet = nil
                    }
                case .credits:
                    CreditsView {
                        viewModel.showSheet = nil
                    }
                }
            }
            .alert(Localizable.RemindersNotAllowed.local(viewModel.language),
                   isPresented: $viewModel.showNotificationAlert) {
                Button(Localizable.cancel.local(viewModel.language), role: .cancel) {}
                Button(Localizable.openAppSettings.local(viewModel.language)) {
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
                            Button(Localizable.done.local(viewModel.language)) {
                                focusedField = nil
                            }
                        }
                    }
                })
        }
    }
}
