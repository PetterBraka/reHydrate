//
//  LanguageService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import LanguageServiceInterface
import LoggingService
import UserPreferenceServiceInterface

public class LanguageService: LanguageServiceType {
    public typealias Engine = (
        HasLoggingService &
        HasUserPreferenceService
    )
    
    private let engine: Engine
    
    private(set) var currentLanguage: Language
    
    public init(engine: Engine) {
        self.engine = engine
        currentLanguage = .english
        currentLanguage = getSelectedLanguage()
    }
    
    public func setLanguage(to language: Language) {
        defer { currentLanguage = language }
        do {
            try engine.userPreferenceService.set(language, for: .language)
        } catch {
            engine.logger.debug("Language couldn't be set", error: error)
        }
    }
    
    public func getSelectedLanguage() -> Language {
        let language: Language? = engine.userPreferenceService.get(for: .language)
        if let language, currentLanguage != language {
            currentLanguage = language
        }
        return language ?? .english
    }
    
    public func getLanguageOptions() -> [Language] {
        Language.allCases
    }
}

extension Language: Codable {}
