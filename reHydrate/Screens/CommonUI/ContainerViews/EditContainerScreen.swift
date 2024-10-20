//
//  EditContainerScreen.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI
import PresentationInterface
import PresentationKit
import EngineKit

struct EditContainerScreen: View {
    @ObservedObject var observer: EditContainerScreenObservable
    @FocusState var isEditing: Bool
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 8) {
            toolBar
                .buttonStyle(.borderless)
            Spacer()
            filledContainer
            VStack {
                slider
                Divider()
                textfieldInput
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.2))
            }
            .padding(16)
        }
        .transaction { $0.animation = nil }
        .onAppear{
            observer.perform(action: .didAppear)
        }
        .overlay {
            if observer.viewModel.isSaving {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                saving
            }
        }
        .presentationDetents([.medium])
    }
    
    var toolBar: some View {
        CustomToolbar {
            Text(title)
        } leadingButton: {
            Button(cancelText) {
                observer.perform(action: .didTapCancel)
            }
            .tint(.red)
            .buttonStyle(.bordered)
        } trailingButton: {
            Button(saveText) {
                observer.perform(action: .didTapSave)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    var image: Image {
        switch observer.viewModel.selectedDrink.container {
        case .small:  Image(.glassFill0)
        case .medium: Image(.bottleFill0)
        case .large: Image(.reusableBottleFill0)
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
                    .frame(width: screenWidth / 4)
            }
            Spacer()
        }
    }
    
    var textfieldInput: some View {
        HStack {
            Text(textFieldTip)
            Spacer()
            TextField(
                "\(observer.size)",
                value: $observer.size,
                formatter: observer.formatter,
                prompt: Text("\(observer.viewModel.selectedDrink.size)")
            )
            .keyboardType(.decimalPad)
            .textCase(.lowercase)
            .focused($isEditing)
            .multilineTextAlignment(.center)
            .fixedSize()
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .opacity(0.25)
            )
            if isEditing {
                Button(doneText) {
                    observer.perform(action: .didChangeSize(size: observer.size))
                    isEditing = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    var slider: some View {
        Slider(
            value: $observer.fill,
            in: 0.1 ... 0.9,
            step: 0.001
        )
        .onChange(of: observer.fill) { oldValue, newValue in
            observer.perform(action: .didChangeFill(fill: newValue))
        }
    }
    
    var saving: some View {
        ProgressView(savingText)
            .controlSize(.large)
            .bold()
            .progressViewStyle(.circular)
            .padding(32)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
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
    
    var textFieldTip: String {
        LocalizedString("ui.edit.container.size.textfiled", value: "Size", comment: "An input field for the user to edit the size of the container")
    }
    
    var saveText: String {
        LocalizedString("ui.edit.container.navigation.save", value: "Save", comment: "The button which will save your edits and go back")
    }
    
    var cancelText: String {
        LocalizedString("ui.edit.container.navigation.cancel", value: "Cancel", comment: "The button which will cancel your edits and go back")
    }
    
    var savingText: String {
        LocalizedString("ui.edit.container.saving", value: "Saving", comment: "A loading wheel showed when something is being saved")
    }
    
    var doneText: String {
        LocalizedString("ui.keyboard.done", value: "Done", comment: "The done button above the keyboard")
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            let presenter = Screen.EditContainer.Presenter(
                engine: Engine.mock,
                router: Router(),
                selectedDrink: .init(id: "test", size: 300, container: .medium)
            )
            let observer = EditContainerScreenObservable(presenter: presenter)
            EditContainerScreen(observer: observer)
        }
}
