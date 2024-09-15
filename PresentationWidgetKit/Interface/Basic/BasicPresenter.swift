//
//  BasicPresenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2024.
//

public protocol BasicPresenter {
    func getViewModel() async -> Basic.ViewModel
    func getEndOfDayViewModel() async -> Basic.ViewModel
}
