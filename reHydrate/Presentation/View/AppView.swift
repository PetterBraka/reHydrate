//
//  AppView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import Presentation

struct AppView: View {
    @ObservedObject var observer: RouterObservable
    @StateObject var viewModel = MainAssembler.shared.container.resolve(AppViewModel.self)!
    @State var homeTransition: AnyTransition = .slide
    
    init() {
        let router = SceneFactory.shared.router
        observer = RouterObservable(router: router, tab: .home)
        router.sceneObserver = observer
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            TabView(selection: $observer.tab) {
                SettingsView(navigateTo: viewModel.navigateTo)
                    .tag(Tab.settings)
                SceneFactory.shared.makeHomeScreen()
                    .tag(Tab.home)
                CalendarView(navigateTo: viewModel.navigateTo)
                    .tag(Tab.history)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            if viewModel.showPopUp {
                Color.gray
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.showPopUp = false
                    }
                if let selectedDrink = viewModel.editingDrink {
                    EditDrinkView(drink: selectedDrink) {
                        viewModel.showPopUp = false
                    }
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
