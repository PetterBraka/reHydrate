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
    private lazy var homePresenter = Screen.Home.Presenter(engine: engine)
//    private lazy var settingsPresenter = Screen.Settings.Presenter(engine: engine, router: router)
    
    private init() {
        let subsystem = "com.braka.reHydrate"
        let appGroup = "group.com.braka.reHydrate.shared"
        engine = MiniEngine(appGroup: appGroup, subsystem: subsystem)
    }
    
    func makeHomeView() -> HomeView {
        let observer = HomeScreenObservable(presenter: homePresenter)
        homePresenter.scene = observer
        
        return HomeView(observer: observer)
    }
}
