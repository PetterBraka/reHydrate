//
//  HomePresenter.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 09/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

public protocol HomePresenterType: AnyObject {
    var viewModel: Home.ViewModel { get }
    func perform(action: Home.Action) async
}
