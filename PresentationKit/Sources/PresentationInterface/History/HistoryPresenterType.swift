//
//  HistoryPresenterType.swift
//
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//

public protocol HistoryPresenterType: AnyObject {
    func perform(action: History.Action) async
}
