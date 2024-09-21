//
//  TodayPresenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/09/2024.
//

public protocol TodayPresenter {
    func getViewModel() async -> Today.ViewModel
    func getEndOfDayViewModel() async -> Today.ViewModel
}
