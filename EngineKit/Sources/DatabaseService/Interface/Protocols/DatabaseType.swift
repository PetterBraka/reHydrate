//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 29/07/2023.
//

import Blackbird

public protocol DatabaseType {
    var db: Blackbird.Database { get }
}
