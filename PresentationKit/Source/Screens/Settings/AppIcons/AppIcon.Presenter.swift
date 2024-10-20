//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 04/11/2023.
//

import LoggingService
import PresentationInterface
import PortsInterface

extension Screen.Settings.AppIcon {
    public final class Presenter: AppIconPresenterType {
        public typealias Engine = (
            HasLoggerService &
            HasAlternateIconsService
        )
        public typealias Router = (
            AppIconRoutable
        )
        
        public typealias ViewModel = AppIcon.ViewModel
        
        private let engine: Engine
        private let router: Router
        
        public var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        public weak var scene: AppIconSceneType?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            self.viewModel = ViewModel(
                isLoading: false,
                selectedIcon: .blackWhite,
                error: nil
            )
            Task(priority: .userInitiated) { [weak self] in
                await self?.initRealViewModel()
            }
        }
        
        public func perform(action: AppIcon.Action) async {
            switch action {
            case .didTapClose:
                router.close()
            case let .didSelectIcon(icon):
                await set(icon)
            case .didDismissAlert:
                updateViewModel(isLoading: false, error: nil)
            }
        }
    }
}

private extension Screen.Settings.AppIcon.Presenter {
    func initRealViewModel() async {
        let iconName = await engine.alternateIconsService.getAlternateIcon()
        let icon: ViewModel.Icon? = if let iconName {
            ViewModel.Icon(rawValue: iconName)
        } else {
            nil
        }
        updateViewModel(isLoading: false, selectedIcon: icon)
    }
}

private extension Screen.Settings.AppIcon.Presenter {
    func updateViewModel(
        isLoading: Bool,
        selectedIcon: ViewModel.Icon? = nil,
        error: ViewModel.Error? = nil
    ) {
        viewModel = .init(
            isLoading: isLoading,
            selectedIcon: selectedIcon ?? viewModel.selectedIcon,
            error: error
        )
    }
}

private extension Screen.Settings.AppIcon.Presenter {
    func set(_ icon: AppIcon.ViewModel.Icon) async {
        guard await engine.alternateIconsService.supportsAlternateIcons()
        else {
            updateViewModel(isLoading: false, error: .donNotSupportAlternateIcons)
            return
        }
        updateViewModel(isLoading: true)
        let error = await engine.alternateIconsService.setAlternateIcon(to: icon.rawValue)
        if let error {
            engine.logger.log(category: .presentationKit, message: "Failed setting icon to \(icon.rawValue)", error: error, level: .error)
            updateViewModel(isLoading: false, error: .failedSettingAlternateIcons)
        } else {
            updateViewModel(isLoading: false, selectedIcon: icon)
        }
    }
}
