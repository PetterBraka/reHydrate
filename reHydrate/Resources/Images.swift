//
//  Images.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import SwiftUI

extension Image {
    static let cup = Image("Cup")
    static let bottle = Image("Bottle")
    static let largeBottle = Image("Flask")
    
    static let logo = Image("reHydrateLogo")
    
    static let circle = Image("circle")
    static let leftSelected = Image("LeftSelected")
    static let midSelected = Image("MidSelected")
    static let rightSelected = Image("RightSelected")
    
    static let waterDrop0 = Image("water.drop.0")
    static let waterDrop25 = Image("water.drop.25")
    static let waterDrop50 = Image("water.drop.50")
    static let waterDrop75 = Image("water.drop.75")
    static let waterDrop100 = Image("water.drop.100")
    
    static let waterDrop = Image("waterDrop")
}

extension UIImage {
    static let cup = UIImage(named: "Cup")
    static let bottle = UIImage(named: "Bottle")
    static let largeBottle = UIImage(named: "Flask")
    
    static let logo = UIImage(named: "reHydrateLogo")
    
    static let circle = UIImage(named: "circle")
    static let leftSelected = UIImage(named: "LeftSelected")
    static let midSelected = UIImage(named: "MidSelected")
    static let rightSelected = UIImage(named: "RightSelected")
    
    static let waterDrop0 = UIImage(named: "water.drop.0")
    static let waterDrop25 = UIImage(named: "water.drop.25")
    static let waterDrop50 = UIImage(named: "water.drop.50")
    static let waterDrop75 = UIImage(named: "water.drop.75")
    static let waterDrop100 = UIImage(named: "water.drop.100")
    
    static let waterDrop = UIImage(named: "waterDrop")
}
