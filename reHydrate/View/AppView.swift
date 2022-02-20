//
//  AppView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import FirebaseAnalytics
import SwiftUI

struct AppView: View {
    @StateObject var viewModel = MainAssembler.shared.container.resolve(AppViewModel.self)!
    @State var homeTransition: AnyTransition = .slide
    @State var waterLevel: CGFloat = 0.3

    var body: some View {
        ZStack {
//            Color.background
//                .ignoresSafeArea()
//            TabView(selection: $viewModel.currenState) {
//                SettingsView(navigateTo: viewModel.navigateTo)
//                    .tag(AppState.settings)
//                HomeView(navigateTo: viewModel.navigateTo)
//                    .tag(AppState.home)
//                CalendarView(navigateTo: viewModel.navigateTo)
//                    .tag(AppState.calendar)
//            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
            WaveView(color: .blue, fillLevel: $waterLevel) {
                Image.largeBottle
                    .resizable()
                    .opacity(0.5)
            }
            .aspectRatio(contentMode: .fit)
            .frame(height: 500)
        }
        .onAppear {
            Analytics.track(event: .startUp)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
