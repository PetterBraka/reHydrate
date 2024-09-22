//
//  HomeView.swift
//  Watch App
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import WidgetKit
import PresentationWatchInterface

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var observer: HomeScreenObservable
    
    var body: some View {
        VStack {
            header
            Divider()
            if observer.viewModel.drinks.isEmpty {
                Text("No container found")
            } else {
                drinksView
            }
        }
        .onAppear {
            observer.perform(action: .didAppear)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            Task {
                switch newValue {
                case .active:
                    break
                case .background, .inactive:
                    await observer.perform(action: .didBackground)
                    WidgetCenter.shared.reloadAllTimelines()
                @unknown default:
                    break
                }
            }
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(spacing: 8) {
            let viewModel = observer.viewModel
            Text("\(viewModel.consumption.clean)/" +
                 "\(viewModel.goal.clean)\(viewModel.unit.symbol)")
            .font(.Theme.title2)
            .bold()
        }
    }
    
    @ViewBuilder
    private var drinksView: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(observer.viewModel.drinks, id: \.id) { drink in
                Button {
                    observer.perform(action: .didTapAddDrink(drink.container))
                } label: {
                    getImage(for: drink)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .containerShape(.rect)
                }
                .buttonStyle(.plain)
                .buttonBorderShape(.roundedRectangle(radius: 8))
            }
        }
    }
    
    @ViewBuilder
    private func getImage(for drink: Home.ViewModel.Drink) -> some View {
        switch drink.container {
        case .small:
            Image(.glassFill75)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
        case .medium:
            Image(.bottleFill75)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 75)
        case .large:
            Image(.reusableBottleFill75)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 90)
        }
    }
}

#Preview {
    SceneFactory.shared.makeHomeView(isPreviews: true)
}
