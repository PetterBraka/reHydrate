//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 01/10/2023.
//
import Foundation

public struct NotificationSettings: Sendable {
    public let isOn: Bool
    public let start: Date?
    public let stop: Date?
    public let frequency: Int?
    
    public init(isOn: Bool, start: Date?, stop: Date?, frequency: Int?) {
        self.isOn = isOn
        self.start = start
        self.stop = stop
        self.frequency = frequency
    }
}
