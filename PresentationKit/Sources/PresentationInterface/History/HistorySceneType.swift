//
//  HistorySceneType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 28/11/2023.
//

public protocol HistorySceneType: AnyObject {
    func perform(update: History.Update)
}
