//
//  Screen.Settings.Presenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import SettingsPresentationInterface
import UnitServiceInterface

extension Screen.Settings {
    public final class Presenter: SettingsPresenterType {
        public typealias Engine = (
            HasUnitService
        )
        public typealias Router = (
            HomeRoutable
        )
        public typealias ViewModel = Settings.ViewModel
        
        private let engine: Engine
        private let router: Router
        public var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        public weak var scene: SettingsSceneType?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            let currentSystem = engine.unitService.getUnitSystem()
            viewModel = .init(unitSystem: .init(from: currentSystem))
        }
        
        public func perform(action: Settings.Action) {
            switch action {
            case .didTapBack:
                router.showHome()
            case let .didSetUnitSystem(system):
                engine.unitService.set(unitSystem: system.toggled())
                let updatedSystem = engine.unitService.getUnitSystem()
                updateViewModel(unitSystem: .init(from: updatedSystem))
            default:
                // TODO: Fix this Petter
                break
            }
        }
    }
}

extension Screen.Settings.Presenter {
    private func updateViewModel(unitSystem: Settings.ViewModel.UnitSystem) {
        viewModel = ViewModel(unitSystem: unitSystem)
    }
}

extension Settings.ViewModel.UnitSystem {
    init(from system: UnitServiceInterface.UnitSystem) {
        switch system {
        case .imperial:
            self = .imperial
        case .metric:
            self = .metric
        }
    }
    
    func toggled() -> UnitSystem {
        switch self {
        case .imperial:
            return .metric
        case .metric:
            return .imperial
        }
    }
}
