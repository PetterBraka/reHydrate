//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

import Foundation
import LoggingService
import PresentationInterface
import PortsInterface

extension Screen.Settings.Credits {
    public final class Presenter: CreditsPresenterType {
        public typealias Engine = (
            HasLoggerService &
            HasOpenUrlService
        )
        public typealias Router = (
            CreditsRoutable
        )
        
        public typealias ViewModel = Credits.ViewModel
        
        private let engine: Engine
        private let router: Router
        
        public var viewModel: ViewModel {
            didSet { scene?.perform(update: .viewModel) }
        }
        
        public weak var scene: CreditsSceneType?
        
        public init(engine: Engine,
                    router: Router) {
            self.engine = engine
            self.router = router
            self.viewModel = ViewModel(
                isLoading: false,
                creditedPeople: [
                    ViewModel.CreditedPerson(
                        name: "Petter Vang Braklsvålet",
                        url: URL(string:"https://petterbraka.github.io/LinkTree/"),
                        emoji: "🇳🇴"
                    ),
                    ViewModel.CreditedPerson(
                        name: "Alexandra Murphy",
                        url: URL(string:"https://beacons.page/alexsmurphy"),
                        emoji: "🇬🇧"
                    ),
                    ViewModel.CreditedPerson(
                        name: "Leo Mehing",
                        url: URL(string:"https://structured.today"),
                        emoji: "🇩🇪"
                    ),
                    ViewModel.CreditedPerson(
                        name: "Sævar Ingi Siggason",
                        url: nil,
                        emoji: "🇮🇸"
                    )
                ],
                error: nil
            )
        }
        
        public func perform(action: Credits.Action) async {
            switch action {
            case .didTapClose:
                router.close()
            case let .didTapPerson(person):
                do {
                    guard let url = person.url else { return }
                    updateViewModel(isLoading: true)
                    try await engine.openUrlService.open(url: url)
                    updateViewModel(isLoading: false)
                } catch {
                    engine.logger.log(
                        category: .presentationKit,
                        message: "Unable to open link to \(person.name)",
                        error: error,
                        level: .error
                    )
                    updateViewModel(isLoading: false, error: .unableToOpenLink)
                }
            case .didTapHelpTranslate:
                do {
                    updateViewModel(isLoading: true)
                    try await engine.openUrlService.email(
                        to: "Petter.braka+reHydrate@gmail.com",
                        cc: nil,
                        bcc: nil,
                        subject: "reHydrate translation",
                        body: "Hey, I would like to help translate reHydrate"
                    )
                    updateViewModel(isLoading: false)
                } catch {
                    engine.logger.log(
                        category: .presentationKit,
                        message: "Unable to create draft email to help",
                        error: error,
                        level: .error
                    )
                    updateViewModel(isLoading: false, error: .unableToOpenLink)
                }
            }
        }
    }
}

extension Screen.Settings.Credits.Presenter {
    private func updateViewModel(
        isLoading: Bool,
        error: Credits.ViewModel.Error? = nil
    ) {
        viewModel = ViewModel(
            isLoading: isLoading,
            creditedPeople: viewModel.creditedPeople,
            error: error
        )
    }
}
