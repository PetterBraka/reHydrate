//
//  BasicPresenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2024.
//

public protocol BasicPresenter {
    func getViewModel() -> Basic.ViewModel
    func getEndOfDayViewModel() -> Basic.ViewModel
}
