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
                .gesture (
                    DragGesture()
                        .onEnded({ drag in
                            if drag.startLocation.x > drag.location.x {
                                print("Swipe Left")
                                viewModel.navigateTo(.calendar)
                            } else {
                                print("Swipe Right")
                                viewModel.navigateTo(.settings)
                            }
                        })
                )
        case .settings:
            SettingsView(navigateTo: viewModel.navigateTo)
                .transition( .slide)
                .onAppear {
                    homeTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                 removal: .move(edge: .leading))
                }
                .gesture (
                    DragGesture()
                        .onEnded({ drag in
                            if drag.startLocation.x > drag.location.x {
                                print("Swipe Left")
                                viewModel.navigateTo(.home)
                            }
                        })
                )
        case .calendar:
            CalendarView(navigateTo: viewModel.navigateTo)
                .transition( .asymmetric(insertion: .move(edge: .trailing),
                                         removal: .move(edge: .leading)))
                .onAppear {
                    homeTransition = .slide
                }
                .gesture (
                    DragGesture()
                        .onEnded({ drag in
                            if drag.startLocation.x < drag.location.x {
                                print("Swipe Right")
                                viewModel.navigateTo(.home)
                            }
                        })
                )
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
