//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

import Foundation

public enum Credits {
    public enum Update {
        case viewModel
    }
    
    public enum Action {
        case didTapPerson(ViewModel.CreditedPerson)
        case didTapHelpTranslate
    }
    
    public struct ViewModel {
        public let isLoading: Bool
        public let creditedPeople: [CreditedPerson]
        public let error: Error?
        
        public init(isLoading: Bool, creditedPeople: [CreditedPerson], error: Error?) {
            self.isLoading = isLoading
            self.creditedPeople = creditedPeople
            self.error = error
        }
    }
}

extension Credits.ViewModel {
    public struct CreditedPerson: Hashable {
        public let name: String
        public let url: URL?
        public let emoji: String
        
        public init(name: String, url: URL?, emoji: String) {
            self.name = name
            self.url = url
            self.emoji = emoji
        }
    }
}

extension Credits.ViewModel {
    public enum Error: Swift.Error {
        case unableToOpenLink
    }
}
