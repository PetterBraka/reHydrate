//
//  EditDrinkView.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 26/02/2022.
//  Copyright © 2022 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

struct EditDrinkView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = EditDrinkViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                VStack {
                    GeometryReader { proxy in
                        let size = proxy.size
                        HStack {
                            WaveView(color: .blue,
                                     fillLevel: $viewModel.fillLevel,
                                     currentFill: $viewModel.fillLabel,
                                     minFillLevel: viewModel.minFill,
                                     maxFillLevel: viewModel.maxFill) {
                                viewModel.selectedDrink?.type?.getImage()
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .opacity(0.5)
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width * 0.6,
                                   height: size.height,
                                   alignment: .bottom)
                            Slider(value: $viewModel.fillLevel,
                                   in: viewModel.minFill ... viewModel.maxFill)
                                .rotationEffect(Angle(degrees: -90))
                                .frame(height: size.height)
                        }
                    }
                    .padding(32)
                    Rectangle()
                        .fill(Color.button)
                        .frame(width: UIScreen.main.bounds.width,
                               height: 2)
                    HStack(alignment: .bottom) {
                        ForEach(viewModel.drinkOptions, id: \.id) { drink in
                            Button {
                                viewModel.select(drink)
                            } label: {
                                drink.type?.getImage()
                                    .resizable()
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke()
                                    .foregroundColor(viewModel.selectedDrink == drink ? .button : .clear)
                            )
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .padding(8)
                        }
                    }
                }
                .onAppear {
                    viewModel.select(viewModel.drinkOptions[1])
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            print("Don't update drink")
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            print("Update the drinks")
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Edit drinks")
                    }
                }
            }
        }
    }
}

struct EditDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        EditDrinkView()
    }
}
