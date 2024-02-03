//
//  CreditsScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import PresentationInterface
import PresentationKit
import EngineKit

struct CreditsScreen: View {
    @ObservedObject var observer: CreditsScreenObservable
    
    var body: some View {
        VStack {
            toolbar
            ScrollView {
                VStack(spacing: 8) {
                    list
                        .padding(16)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.tableViewBackground)
                        }
                    helpTranslateButton
                        .padding(16)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.tableViewBackground)
                        }
                }
            }
            .padding(16)
        }
    }
    
    var toolbar: some View {
        CustomToolbar {
            Text(toolbarTitle)
                .bold()
        } trailingButton: {
            Button(closeButtonTitle) {
                observer.perform(action: .didTapClose)
            }
        }
    }
    
    var list: some View {
        VStack(spacing: 16) {
            ForEach(observer.viewModel.creditedPeople, id: \.self) { person in
                Button {
                    observer.perform(action: .didTapPerson(person))
                } label: {
                    HStack(spacing: 8) {
                        Text(person.name)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .underline(person.url != nil)
                        Spacer()
                        Text(person.emoji)
                    }
                    .contentShape(Rectangle())
                }
                .font(.brandBody)
                .foregroundColor(.label)
                .disabled(person.url == nil)
                if person != observer.viewModel.creditedPeople.last {
                    Divider()
                }
            }
        }
    }
    
    var helpTranslateButton: some View {
        Button {
            observer.perform(action: .didTapHelpTranslate)
        } label: {
            HStack {
                Text(LocalizedString(
                    "ui.settings.credits.helpTranslate",
                    value: "Help translate the app",
                    comment: "Asks the user if they would like to help translate the app"
                ))
                Spacer()
                Image.open
            }
            .contentShape(Rectangle())
            .font(.brandBody)
            .foregroundColor(.label)
            .multilineTextAlignment(.leading)
        }
    }
}

extension CreditsScreen {
    var toolbarTitle: String {
        LocalizedString(
            "ui.settings.credits.navigation.title",
            value: "Credits",
            comment: "A navigation bar title"
        )
    }
    
    var closeButtonTitle: String {
        LocalizedString(
            "ui.settings.credits.navigation.close",
            value: "Close",
            comment: "A navigation bar button"
        )
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            let presenter = Screen.Settings.Credits.Presenter(engine: Engine.mock, router: Router())
            let observer = CreditsScreenObservable(presenter: presenter)
            CreditsScreen(observer: observer)
        }
}
