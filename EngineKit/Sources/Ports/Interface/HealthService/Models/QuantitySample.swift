//
//  QuantitySample.swift
//  
//
//  Created by Petter vang Brakalsvålet on 25/11/2023.
//

public struct QuantitySample {
    public let quantityTypeID: QuantityTypeIdentifier
    public let quantity: Quantity
    
    public init(quantityTypeID: QuantityTypeIdentifier, quantity: Quantity) {
        self.quantityTypeID = quantityTypeID
        self.quantity = quantity
    }
}
