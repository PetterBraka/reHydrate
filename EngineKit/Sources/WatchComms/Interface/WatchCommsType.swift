//
//  WatchCommsType.swift
//
//
//  Created by Petter vang Brakalsvålet on 11/08/2024.
//

public protocol WatchCommsType {
    func setAppContext() async
    func sendDataToPhone() async
}
