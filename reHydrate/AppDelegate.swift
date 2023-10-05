//
//  AppDelegate.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 12/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import EngineKit

class AppDelegate: NSObject, UIApplicationDelegate {
    public let sceneFactory = SceneFactory()
    var engine: Engine { sceneFactory.engine }
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool {
        UNUserNotificationCenter.current().delegate = sceneFactory.notificationDelegate
        return true
    }
}
