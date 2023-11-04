//
//  AppIconScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import CreditsPresentationInterface
import PresentationKit
import EngineKit

struct AppIconScreen: View {
    @ObservedObject var observer: AppIconScreenObservable
    
    var body: some View {
        VStack {
            toolbar
            ScrollView(.vertical) {
                appIconGrid
                    .padding(16)
            }
         }
    }
    
    @ViewBuilder
    var toolbar: some View {
        CustomToolbar {
            Text(toolbarPrincipleTitle)
        } trailingButton: {
            Button(toolbarLeadingTitle) {
                observer.perform(action: .didTapClose)
            }
            .buttonStyle(.bordered)
        }
    }
    
    @ViewBuilder
    var appIconGrid: some View {
        let columns = [GridItem].init(repeating: GridItem(.flexible()), count: 3)
        LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
            ForEach(observer.viewModel.allIcons, id: \.self) { icon in
                let cornerRadius: CGFloat = 16
                let isSelected = observer.viewModel.selectedIcon == icon
                if let image = UIImage(named: icon.rawValue) {
                    Button {
                        observer.perform(action: .didSelectIcon(icon))
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.blue, lineWidth: isSelected ? 4 : 0)
                    }
                    .shadow(radius: 4)
                    .padding(8)
                } else {
                    #if DEBUG
                    Text("Failed getting **\(icon.rawValue)**")
                    #endif
                }
            }
        }
    }
}

extension AppIconScreen {
    var toolbarPrincipleTitle: String {
        LocalizedString(
            "ui.settings.appIcon.title",
            value: "Change app icon",
            comment: "Button which shows the user the different App icon options"
        )
    }
    
    var toolbarLeadingTitle: String {
        LocalizedString(
            "ui.appIcon.done.button",
            value: "Done",
            comment: "Done button"
        )
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            let presenter = Screen.Settings.AppIcon.Presenter(engine: Engine.mock, router: Router())
            let observer = AppIconScreenObservable(presenter: presenter)
            AppIconScreen(observer: observer)
        }
}
