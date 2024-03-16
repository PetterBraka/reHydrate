//
//  SceneFactory.swift
//  reHydrateWatch App
//
//  Created by Petter vang Brakalsvålet on 10/02/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import PresentationWatchKit
import PresentationWatchInterface
import EngineKit
import LoggingService
import DrinkServiceInterface
import UserNotifications
import UIKit

public final class SceneFactory: ObservableObject {
    static let shared = SceneFactory()
    
    private let engine: MiniEngine
    
    // Root presenters
    
    private init() {
        let subsystem = "com.braka.reHydrate"
        let appGroup = "group.com.braka.reHydrate.shared"
        engine = MiniEngine(appGroup: appGroup, subsystem: subsystem)
    }
    
    func makeHomeView(isPreviews: Bool = false) -> HomeView {
        let presenter = Screen.Home.Presenter(engine: engine)
        let observer = HomeScreenObservable(presenter: presenter)
        presenter.scene = observer
        
        return HomeView(observer: observer)
    }
}
