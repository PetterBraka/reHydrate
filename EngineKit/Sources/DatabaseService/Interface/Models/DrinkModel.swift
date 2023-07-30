//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird
import Foundation

// TODO: Petter support this
struct DrinkModel: BlackbirdModel {
    @BlackbirdColumn var id: String
    @BlackbirdColumn var size: Date
}
