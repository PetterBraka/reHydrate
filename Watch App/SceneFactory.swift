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
import WatchEngine
import LoggingService
import DrinkServiceInterface
import UserNotifications
import UIKit
import WatchConnectivity
import CommunicationKit
import CommunicationKitInterface

public final class SceneFactory: ObservableObject {
    static let shared = SceneFactory()
    
    public let engine: WatchEngine
    private let watchDelegate: WCSessionDelegate
    private let notificationCenter: NotificationCenter
    
    private init() {
        let subsystem = "com.braka.reHydrate.watchkitapp"
        let appGroup = "group.com.braka.reHydrate.shared"
        let watchSession = WCSession.default
        self.notificationCenter = NotificationCenter.default
        
        engine = WatchEngine(
            appGroup: appGroup,
            subsystem: subsystem,
            watchService: WatchService(session: watchSession), notificationCenter: notificationCenter
        )
        self.watchDelegate = WatchCommunicationDelegate(session: watchSession, notificationCenter: notificationCenter)
        self.engine.watchService.activate()
    }
    
    func makeHomeView(isPreviews: Bool = false) -> HomeView {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE - dd MMM", options: 0, locale: .current)
        let presenter = Screen.Home.Presenter(engine: engine, formatter: formatter, notificationCenter: notificationCenter)
        let observer = HomeScreenObservable(presenter: presenter)
        presenter.scene = observer
        
        return HomeView(observer: observer)
    }
}
