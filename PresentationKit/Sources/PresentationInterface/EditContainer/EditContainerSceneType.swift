//
//  EditContainerSceneType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/10/2023.
//

public protocol EditContainerSceneType: AnyObject {
    func perform(update: EditContainer.Update)
}
