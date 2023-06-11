//
//  SceneFactory.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//  Copyright © 2023 Petter vang Brakalsvålet. All rights reserved.
//

import EngineKit
import Presentation

public final class SceneFactory {
    let engine = Engine()
    let router = Router()
    
    init() {}
    
    func makeHomeScreen() -> HomeScreen {
        let presenter = Screen.Home.Presenter(engine: engine,
                                              router: router)
        
        let observer = HomeScreenObservable(presenter: presenter,
                                            date: .now, consumed: 0, goal: 3,
                                            drinks: [.init(size: 300, container: .small),
                                                     .init(size: 500, container: .medium),
                                                     .init(size: 750, container: .large)],
                                            unit: (small: .milliliters, large: .liters))
        presenter.scene = observer
        
        return HomeScreen(observer: observer)
    }
}
