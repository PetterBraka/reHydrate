//
//  HomeScreenType.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//

public protocol HomeSceneType: AnyObject {
    func perform(update: Home.Update)
}

public protocol HomePresenterType: AnyObject {
    var viewModel: Home.ViewModel { get }
    func perform(action: Home.Action) async
    func sync(didComplete: (() -> Void)?)
}

