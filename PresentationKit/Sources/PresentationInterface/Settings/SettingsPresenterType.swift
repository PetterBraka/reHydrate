//
//  SettingsPresenterType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/06/2023.
//

public protocol SettingsPresenterType: AnyObject {
    func perform(action: Settings.Action) async
}
