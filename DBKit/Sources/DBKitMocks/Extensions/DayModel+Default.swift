//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 17/02/2024.
//

import DBKitInterface

package extension DayModel {
    static var `default` = DayModel(id: "", date: "", consumed: 0, goal: 0)
}
package extension Result where Success == DayModel, Failure == Error {
    static var `default` = Result<Success, Failure>.success(.default)
}

package extension Result where Success == [DayModel], Failure == Error {
    static var `default` = Result<Success, Failure>.success([.default])
}
