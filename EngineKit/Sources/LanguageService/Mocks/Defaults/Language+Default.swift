//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import LanguageServiceInterface

extension Language {
    static let `default` = Language.english
}

extension Array where Element == Language {
    static let `default` = [Language.default]
}
