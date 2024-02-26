//
//  HomeRoutable.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/06/2023.
//

import PresentationInterface

public protocol HomeRoutable {
    func showSettings()
    func showHistory()
    func showEdit(drink: Home.ViewModel.Drink)
}
