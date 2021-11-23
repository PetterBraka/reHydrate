//
//  SettingsView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 23/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    
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
                
                VStack {
                    Spacer()
                }
                .padding(.horizontal, 16)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .font(.largeTitle)
                            .foregroundColor(.label)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.navigateToHome()
                        } label: {
                            Image.exit
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(.largeTitle)
                                .foregroundColor(.label)
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
