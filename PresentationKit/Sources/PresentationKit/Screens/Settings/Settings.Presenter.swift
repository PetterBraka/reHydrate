//
//  Screen.Settings.Presenter.swift
//
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import SettingsPresentationInterface
import UnitServiceInterface
import DayServiceInterface

extension Screen.Settings {
    public final class Presenter: SettingsPresenterType {
        public typealias Engine = (
            HasDayService &
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
            viewModel = .init(
                unitSystem: .metric,
                goal: 0
            )
            Task(priority: .high) {
                await initRealViewModel()
            }
        }
        
        private func initRealViewModel() async {
            let currentSystem = engine.unitService.getUnitSystem()
            let goal = await engine.dayService.getToday().goal
            viewModel = .init(
                unitSystem: .init(from: currentSystem),
                goal: goal
            )
        }
        
        public func perform(action: Settings.Action) {
            switch action {
            case .didTapBack:
                router.showHome()
            case .didTapIncrementGoal:
                increaseGoal()
            case .didTapDecrementGoal:
                decreaseGoal()
            case let .didSetUnitSystem(system):
                engine.unitService.set(unitSystem: .init(from: system))
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
    private func updateViewModel(
        unitSystem: Settings.ViewModel.UnitSystem,
        goal: Double
    ) {
        viewModel = ViewModel(
            unitSystem: unitSystem,
            goal: goal
        )
    }
    private func updateViewModel(
        unitSystem: Settings.ViewModel.UnitSystem? = nil,
        goal: Double? = nil
    ) {
        updateViewModel(
            unitSystem: unitSystem ?? viewModel.unitSystem,
            goal: goal ?? viewModel.goal
        )
    }
}

extension Screen.Settings.Presenter {
    private func increaseGoal() {
        Task {
            do {
                let newGoal = try await engine.dayService.increase(goal: 0.5)
                updateViewModel(goal: newGoal)
            }
        }
    }
    private func decreaseGoal() {
        Task {
            do {
                let newGoal = try await engine.dayService.decrease(goal: 0.5)
                updateViewModel(goal: newGoal)
            }
        }
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
}

extension UnitSystem {
    init(from system: Settings.ViewModel.UnitSystem) {
        switch system {
        case .imperial:
            self = .imperial
        case .metric:
            self = .metric
        }
    }
}
