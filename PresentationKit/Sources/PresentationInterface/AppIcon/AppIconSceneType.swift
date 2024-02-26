//
//  AppIconSceneType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//

public protocol AppIconSceneType: AnyObject {
    func perform(update: AppIcon.Update)
}
