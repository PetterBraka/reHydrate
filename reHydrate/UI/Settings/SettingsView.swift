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
                                       highlightedImage: .darkMode) {
                            viewModel.toggleDarkMode()
                        }
                        HStack {
                            Text(Localizable.Setting.appIcon)
                            Spacer()
                            Image.open
                        }
                        OptionsButton(title: Localizable.Setting.Language.language,
                                      selectedItem: $viewModel.selectedLanguage,
                                      items: viewModel.languages)
                    }
                    .listRowBackground(Color.tableViewBackground)
                    .padding(.vertical, 8)
                    Section {
                        HStack {
                            Text(Localizable.Setting.units)
                            Spacer()
                            Picker("", selection: $viewModel.selectedUnit) {
                                Text(Localizable.Setting.metricSystem)
                                    .tag(Localizable.Setting.metricSystem)
                                Text(Localizable.Setting.imperialSystem)
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
                            Text("\(Localizable.Setting.setYourGoal):")
                            Spacer()
                            TextField(Localizable.Setting.goal,
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
