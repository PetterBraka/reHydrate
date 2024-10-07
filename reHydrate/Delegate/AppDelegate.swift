//
//  AppDelegate.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 12/12/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import UIKit
import EngineKit
import WidgetKit

class AppDelegate: NSObject, UIApplicationDelegate {
    public let sceneFactory = SceneFactory.shared
    var engine: Engine { sceneFactory.engine }
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool {
        WidgetCenter.shared.getCurrentConfigurations { results in
            switch results {
            case let .success(widgets):
                print(widgets)
                for widget in widgets {
                    WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
                }
            case let .failure(error):
                print(error)
            }
        }
        return true
    }
}
