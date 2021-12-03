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
    @State var goal = ""
    
    @FocusState private var focusedField: Field?
    
    init(navigateTo: @escaping ((AppState) -> Void)) {
        let viewModel = MainAssembler.shared.container.resolve(SettingsViewModel.self,
                                                               argument: navigateTo)!
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                Form {
                    Section {
                        CheckBoxButton(isChecked: $viewModel.isDarkMode,
                                       text: Localizable.Setting.lightMode,
                                       highlightedText: Localizable.Setting.darkMode,
                                       image: .lightMode,
                                       highlightedImage: .darkMode,
                                       language: $viewModel.language) {
                            viewModel.toggleDarkMode()
                        }
                        HStack {
                            Text("AppIcon".local(viewModel.language))
                            Spacer()
                            Image.open
                        }
                        OptionsButton(title: Localizable.Setting.Language.language,
                                      selectedItem: $viewModel.selectedLanguage,
                                      items: viewModel.languages,
                                      language: $viewModel.language)
                    }
                    .listRowBackground(Color.tableViewBackground)
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
                    Section {
                        HStack {
                            Text(Localizable.Setting.setYourGoal.local(viewModel.language))
                            Spacer()
                            StepperView(value: $viewModel.selectedGoal) {
                                viewModel.incrementGoal()
                            } onDecrement: {
                                viewModel.decrementGoal()
                            }
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    Section {
                        CheckBoxButton(isChecked: $viewModel.remindersOn,
                                       text: Localizable.Setting.Reminders.turnOnReminders,
                                       highlightedText: Localizable.Setting.Reminders.turnOffReminders,
                                       image: .remindersOff,
                                       highlightedImage: .remindersOn,
                                       language: $viewModel.language) {
                                viewModel.toggleReminders()
                        }
                        if viewModel.remindersOn {
                            HStack {
                                Text(Localizable.Setting.Reminders.startingTime.local(viewModel.language))
                                Spacer()
                                DatePicker("", selection: $viewModel.startDate, displayedComponents: .hourAndMinute)
                            }
                            HStack {
                                Text(Localizable.Setting.Reminders.endingTime.local(viewModel.language))
                                Spacer()
                                DatePicker("", selection: $viewModel.endDate, displayedComponents: .hourAndMinute)
                            }
                            HStack {
                                Text(Localizable.Setting.Reminders.frequency.local(viewModel.language))
                                Spacer()
                                StepperView(value: $viewModel.frequency) {
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
                .toolbar(content: {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button(Localizable.done) {
                                focusedField = nil
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.navigateToHome()
                        } label: {
                            Image.back
                                .font(.largeTitle)
                                .foregroundColor(.button)
                        }
                    }
                })
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView() {_ in}
    }
}
