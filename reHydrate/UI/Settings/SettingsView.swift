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
                            Text("AppIcon".localized(viewModel.language))
                            Spacer()
                            Image.open
                        }
                        OptionsButton(title: Localizable.Setting.Language.language,
                                      selectedItem: $viewModel.selectedLanguage,
                                      items: viewModel.languages,
                                      language: $viewModel.language)
                    }
                    .listRowBackground(Color.tableViewBackground)
                    .padding(.vertical, 8)
                    Section {
                        HStack {
                            Text(Localizable.Setting.units.localized(viewModel.language))
                            Spacer()
                            Picker("", selection: $viewModel.selectedUnit) {
                                Text(Localizable.Setting.metricSystem.localized(viewModel.language))
                                    .tag(Localizable.Setting.metricSystem)
                                Text(Localizable.Setting.imperialSystem.localized(viewModel.language))
                                    .tag(Localizable.Setting.imperialSystem)
                            }
                            .pickerStyle(.segmented)
                            .fixedSize()
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    .padding(.vertical, 8)
                    Section {
                        HStack {
                            Text(Localizable.Setting.setYourGoal.localized(viewModel.language))
                            Spacer()
                            TextField(Localizable.Setting.goal.localized(viewModel.language),
                                      text: $viewModel.selectedGoal)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .truncationMode(.tail)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder()
                                )
                                .fixedSize()
                                .focused($focusedField, equals: .goal)
                                .foregroundColor(.label)
                        }
                    }
                    .listRowBackground(Color.tableViewBackground)
                    .padding(.vertical, 8)
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
