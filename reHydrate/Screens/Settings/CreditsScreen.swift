//
//  CreditsScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 29/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import CreditsPresentationInterface
import PresentationKit
import EngineKit

struct CreditsScreen: View {
    @ObservedObject var observer: CreditsScreenObservable
    
    var body: some View {
        ScrollView {
            list
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.tableViewBackground)
                }
                .padding(.bottom, 8)
            helpTranslateButton
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.tableViewBackground)
                }
        }
        .padding(.horizontal, 16)
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

#Preview {
    let presenter = Screen.Settings.Credits.Presenter(engine: Engine.mock, router: Router())
    let observer = CreditsScreenObservable(presenter: presenter)
    return CreditsScreen(observer: observer)
}
