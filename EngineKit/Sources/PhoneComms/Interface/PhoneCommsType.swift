//
//  PhoneCommsType.swift
//
//
//  Created by Petter vang Brakalsvålet on 11/08/2024.
//

public protocol PhoneCommsType {
    func setAppContext() async
    func sendDataToWatch() async
}
