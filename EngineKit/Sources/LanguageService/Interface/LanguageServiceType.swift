//
//  LanguageServiceType.swift
//  
//
//  Created by Petter vang Brakalsvålet on 16/07/2023.
//

public protocol LanguageServiceType {
    func getSelectedLanguage() -> Language
    func getLanguageOptions() -> [Language]
}
