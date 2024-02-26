//
//  AppIconPresenterType.swift
//
//
//  Created by Petter vang Brakalsvålet on 03/11/2023.
//

public protocol AppIconPresenterType: AnyObject {
    func perform(action: AppIcon.Action) async
}
