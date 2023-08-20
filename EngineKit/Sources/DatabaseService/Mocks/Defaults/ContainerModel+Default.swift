//
//  ContainerModel+Default.swift
//  
//
//  Created by Petter vang Brakalsvålet on 20/08/2023.
//

import DatabaseServiceInterface

extension ContainerModel {
    static let `default` = ContainerModel(id: "---", size: 0)
}

extension Array where Element == ContainerModel {
    static let `default` = [ContainerModel.default]
}

