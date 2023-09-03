//
//  LanguageServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

public protocol LanguageServiceType {
    func setLanguage(to language: Language)
    func getSelectedLanguage() -> Language
    func getLanguageOptions() -> [Language]
}
