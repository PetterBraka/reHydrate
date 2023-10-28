//
//  EditContainerScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import EditContainerPresentationInterface

struct EditContainerScreen: View {
    @ObservedObject var observer: EditContainerScreenObservable
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            toolBar
                .buttonStyle(.borderless)
            filledContainer
            List {
                slider
                    .listRowBackground(Color.gray.opacity(0.1))
                textfieldInput
                    .listRowBackground(Color.gray.opacity(0.1))
            }
            .listStyle(.insetGrouped)
            .listRowSeparator(.visible)
            .scrollContentBackground(.hidden)
        }
        .overlay {
//            if observer.viewModel.isLoading {
            Color.black.opacity(0.25)
                loading
//            }
        }
    }
    
    var toolBar: some View {
        Grid {
            GridRow {
                Button(
                    LocalizedString(
                        "ui.edit.container.navigation.cancel",
                        value: "Cancel",
                        comment: "The button which will cancel your edits and go back")
                ) {
                    observer.perform(action: .didTapCancel)
                }
                Text(title)
                    .frame(maxWidth: .infinity)
                Button(
                    LocalizedString(
                        "ui.edit.container.navigation.save",
                        value: "Save",
                        comment: "The button which will save your edits and go back")
                ) {
                    observer.perform(action: .didTapSave(observer.size))
                }
                .bold()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
    
    var image: Image {
        switch observer.viewModel.selectedDrink.container {
        case .small: .glass
        case .medium: .bottle
        case .large: .reusableBottle
        }
    }
    
    var filledContainer: some View {
        HStack {
            Spacer()
            FilledContainer(
                fill: observer.fill,
                waveHeight: 5
            ) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: screenWidth)
            }
            Spacer()
        }
    }
    
    var textfieldInput: some View {
        HStack {
            Text(LocalizedString("ui.edit.container.size.textfiled", value: "Size", comment: "An input field for the user to edit the size of the container"))
            Spacer()
            TextField(
                "\(observer.size)",
                value: $observer.size,
                formatter: observer.formatter,
                prompt: Text("\(observer.viewModel.selectedDrink.size)")
            )
            .keyboardType(.decimalPad)
            .textContentType(.none)
            .textCase(.lowercase)
            .multilineTextAlignment(.center)
            .fixedSize()
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .opacity(0.25)
            )
            .onSubmit {
                observer.perform(action: .didChangeSize(size: observer.size))
            }
        }
    }
    
    var slider: some View {
        Slider(
            value: $observer.fill,
            in: observer.range,
            step: 0.025
        )
        .onChange(of: observer.fill) { oldValue, newValue in
            observer.perform(action: .didChangeFill(fill: newValue))
        }
    }
    
    var loading: some View {
        ProgressView(loadingText)
            .controlSize(.large)
            .bold()
            .progressViewStyle(.circular)
            .padding(32)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            }
    }
}

private extension EditContainerScreen {
    var containerText: String {
        switch observer.viewModel.selectedDrink.container {
        case .small:
            LocalizedString("ui.edit.container.small.title", value: "small", comment: "The small container")
        case .medium:
            LocalizedString("ui.edit.container.medium.title", value: "medium", comment: "The medium container")
        case .large:
            LocalizedString("ui.edit.container.large.title", value: "large", comment: "The large container")
        }
    }
    
    var title: String {
        LocalizedString("ui.edit.container.title", value: "Edit %@", arguments: containerText, comment: "The title of the screen where you edit your container")
    }
    
    var loadingText: String {
        LocalizedString("ui.edit.container.loading", value: "Loading", comment: "A loading wheel showed when something is being processed")
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            EditContainerScreen(observer: .mock)
        }
}
