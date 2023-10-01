//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 01/10/2023.
//

public struct NotificationSettings {
    public let isOn: Bool
    public let start: String?
    public let stop: String?
    public let frequency: Int?
    
    public init(isOn: Bool, start: String?, stop: String?, frequency: Int?) {
        self.isOn = isOn
        self.start = start
        self.stop = stop
        self.frequency = frequency
    }
}
