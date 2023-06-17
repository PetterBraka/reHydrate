//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import SettingsPresentationInterface

extension Screen.Settings {
    public final class Presenter: SettingsPresenterType {
        public typealias Engine = (
            AnyObject
        )
        public typealias Router = (
            HomeRoutable
        )
        
        private let engine: Engine
        private let router: Router
        
        public weak var scene: SettingsSceneType?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
        }
        
        public func perform(action: Settings.Action) {
            switch action {
            case .didTapBack:
                router.showHome()
            default:
                // TODO: Fix this Petter
                break
            }
        }
    }
}
