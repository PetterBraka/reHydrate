//
//  SettingsSceneType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/06/2023.
//

public protocol SettingsSceneType: AnyObject {
    func perform(update: Settings.Update)
}
