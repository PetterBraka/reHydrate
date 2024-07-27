//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 30/06/2024.
//

import Foundation

extension Notification.Name {
    public enum Phone {
        public static let didBecomeInactive = Notification.Name("sessionDidBecomeInactive")
        public static let didDeactivate = Notification.Name("sessionDidDeactivate")
    }
    
    public enum Shared {
        public static let activation = Notification.Name("sessionActivationDidComplete")
        public static let reachabilityDidChange = Notification.Name("sessionReachabilityDidChange")
        public static let didReceiveApplicationContext = Notification.Name("sessionDidReceiveApplicationContext")
        public static let didReceiveMessage = Notification.Name("sessionDidReceiveMessage")
        public static let messageReplay = Notification.Name("messageReplay")
        public static let didReceiveMessageData = Notification.Name("sessionDidReceiveMessageData")
        public static let messageDataReplay = Notification.Name("messageDataReplay")
        public static let didReceiveUserInfo = Notification.Name("sessionDidReceiveUserInfo")
    }
}
