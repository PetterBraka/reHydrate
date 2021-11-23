//
//  AppView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct AppView: View {
    @StateObject var viewModel = MainAssembler.shared.container.resolve(AppViewModel.self)!
    @State var homeTransition: AnyTransition = .slide
    
    var body: some View {
        switch viewModel.currenState {
        case .home:
            HomeView(navigateTo: viewModel.navigateTo)
                .transition(homeTransition)
        case .settings:
            SettingsView(navigateTo: viewModel.navigateTo)
                .transition( .slide)
                .onAppear {
                    homeTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                 removal: .move(edge: .leading))
                }
        case .calendar:
            CalendarView(navigateTo: viewModel.navigateTo)
                .transition( .asymmetric(insertion: .move(edge: .trailing),
                                         removal: .move(edge: .leading)))
                .onAppear {
                    homeTransition = .slide
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
