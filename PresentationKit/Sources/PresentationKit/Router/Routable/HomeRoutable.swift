//
//  HomeRoutable.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import HomePresentationInterface

public protocol HomeRoutable {
    func showSettings()
    func showEdit(drink: Home.ViewModel.Drink)
}
