//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/02/2024.
//

import DBKitInterface

package extension ConsumptionModel {
    static let `default` = ConsumptionModel(id: "", date: "", time: "", consumed: 0)
}
package extension Result where Success == ConsumptionModel, Failure == Error {
    static let `default` = Result<Success, Failure>.success(.default)
}

package extension Result where Success == [ConsumptionModel], Failure == Error {
    static let `default` = Result<Success, Failure>.success([.default])
}
