//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/02/2024.
//

import DBKitInterface

package extension DrinkModel {
    static let `default` = DrinkModel(id: "", size: 300, container: "small")
}
package extension Result where Success == DrinkModel, Failure == Error {
    static let `default` = Result<Success, Failure>.success(.default)
}

package extension Result where Success == [DrinkModel], Failure == Error {
    static let `default` = Result<Success, Failure>.success([
        .init(id: "", size: 300, container: "small"),
        .init(id: "", size: 500, container: "medium"),
        .init(id: "", size: 750, container: "large")
    ])
}
