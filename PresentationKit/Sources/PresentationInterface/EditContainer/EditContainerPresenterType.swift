//
//  EditContainerPresenterType.swift
//
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//

public protocol EditContainerPresenterType: AnyObject {
    var viewModel: EditContainer.ViewModel { get }
    func perform(action: EditContainer.Action) async
}
