//
//  ContentView.swift
//  reHydrateWatch App
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var observer: HomeScreenObservable
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(spacing: 8) {
            Text("\(observer.viewModel.consumption.clean)" +
                 "/" +
                 "\(observer.viewModel.goal.clean)" +
                 "\(observer.viewModel.largeUnit.symbol)")
            .font(.Theme.title2)
            .bold()
            .padding(.top, 16)
        }
    }
}

#Preview {
    SceneFactory.shared.makeHomeView()
}
