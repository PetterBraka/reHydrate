//
//  AppView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import PresentationKit

struct AppView: View {
    @ObservedObject var observer: RouterObservable
    let sceneFactory = SceneFactory.shared
    
    init() {
        let router = sceneFactory.router
        observer = RouterObservable(router: router, tab: .home)
        router.sceneObserver = observer
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            TabView(selection: $observer.tab) {
                sceneFactory.makeSettingsScreen()
                    .tag(Tab.settings)
                sceneFactory.makeHomeScreen()
                    .tag(Tab.home)
                sceneFactory.makeHistoryScreen()
                    .tag(Tab.history)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .sheet(item: $observer.popUp) { popup in
            sheets(for: popup)
        }
    }
    
    @ViewBuilder
    func sheets(for popup: PopUp) -> some View {
        switch popup {
        case let .edit(drink):
            sceneFactory.makeEditScreen(with: drink)
        case .credits:
            sceneFactory.makeCreditsScreen()
        case .appIcon:
            sceneFactory.makeAppIconScreen()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
