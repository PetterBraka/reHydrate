//
//  LanguageService.swift
//  
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

import LanguageServiceInterface

public class LanguageService: LanguageServiceType {
    public init() {}
    
    public func getSelectedLanguage() -> LanguageServiceInterface.Language {
        .english
    }
    
    public func getLanguageOptions() -> [LanguageServiceInterface.Language] {
        Language.allCases
    }
}
