//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import Blackbird
import Foundation

public struct DummyModel: BlackbirdModel {
    @BlackbirdColumn public var id: String
    @BlackbirdColumn public var text: String
    
    public init(id: String = UUID().uuidString, text: String) {
        self.id = id
        self.text = text
    }
}
