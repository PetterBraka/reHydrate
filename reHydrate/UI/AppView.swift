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
    
    var body: some View {
        switch viewModel.currenState {
        case .home:
            HomeView(drinks: $viewModel.drinks,
                     navigateTo: viewModel.navigateTo)
                .transition(.slide)
        case .settings:
            Text("Settings")
                .transition( .asymmetric(insertion: .move(edge: .leading),
                                         removal: .move(edge: .trailing)))
        case .calender:
            Text("Calender")
                .transition( .asymmetric(insertion: .move(edge: .trailing),
                                         removal: .move(edge: .leading)))
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
