//
//  HomeScreenType.swift
//
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//

public protocol HomeSceneType: AnyObject {
    func perform(update: Home.Update)
}

public protocol HomePresenterType: AnyObject {
    var viewModel: Home.ViewModel { get }
    func perform(action: Home.Action) async
}
