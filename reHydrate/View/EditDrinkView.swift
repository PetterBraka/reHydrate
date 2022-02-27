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
    @State var fillLevel: CGFloat = 0.3
    @State var drinkOptions: [Drink] = [
        Drink(type: .small, size: 300),
        Drink(type: .medium, size: 500),
        Drink(type: .large, size: 750)
    ]
    @State var selectedDrink: Drink?

    var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                VStack {
                    WaveView(color: .blue, fillLevel: $fillLevel) {
                        selectedDrink?.type?.getImage()
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.5)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.75,
                           alignment: .bottom)
                    .padding(32)
                    HStack(alignment: .bottom, spacing: 16) {
                        ForEach(drinkOptions, id: \.id) { drink in
                            Button {
                                selectedDrink = drink
                            } label: {
                                drink.type?.getImage()
                                    .resizable()
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke()
                                    .foregroundColor(selectedDrink == drink ? .button : .clear)
                            )
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .padding(8)
                        }
                    }
                }
                .onAppear {
                    selectedDrink = drinkOptions[1]
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
