//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/02/2024.
//

import DBKitInterface

package extension DayModel {
    static let `default` = DayModel(id: "", date: "", consumed: 0, goal: 0)
}
package extension Result where Success == DayModel, Failure == Error {
    static let `default` = Result<Success, Failure>.success(.default)
}

package extension Result where Success == [DayModel], Failure == Error {
    static let `default` = Result<Success, Failure>.success([.default])
}
