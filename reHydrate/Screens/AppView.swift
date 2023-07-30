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
                SceneFactory.shared.makeHomeScreen()
                    .tag(Tab.home)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            if case .some = observer.popUp {
                Color.gray
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        observer.dismissPopUp()
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
