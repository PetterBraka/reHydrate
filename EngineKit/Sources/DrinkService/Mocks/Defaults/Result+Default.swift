//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import DrinkServiceInterface

extension Result where Success == Drink, Failure == DrinkDBError {
    static let `default` = Result<Drink, DrinkDBError>.success(.default)
}

extension Result where Success == [Drink], Failure == DrinkDBError {
    static let `default` = Result<[Drink], DrinkDBError>.success(.default)
}

extension Result where Success == Void, Failure == DrinkDBError {
    static let `default` = Result<Void, DrinkDBError>.success(Void())
}
