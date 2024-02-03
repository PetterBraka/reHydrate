//
//  CreditsPresenterType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

public protocol CreditsPresenterType: AnyObject {
    func perform(action: Credits.Action) async
}
