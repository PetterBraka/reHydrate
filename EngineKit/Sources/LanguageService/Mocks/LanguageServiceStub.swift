//
//  File.swift
//  
//
//  Created by Petter vang Brakalsvålet on 14/08/2023.
//

import LanguageServiceInterface

public protocol LanguageServiceStubbing {
    var getSelectedLanguage_returnValue: Language { get set }
    var getLanguageOptions_returnValue: [Language] { get set }
}

public final class LanguageServiceStub: LanguageServiceStubbing {
    public init() {}
    
    public var getSelectedLanguage_returnValue: Language = .default
    public var getLanguageOptions_returnValue: [Language] = .default
}

extension LanguageServiceStub: LanguageServiceType {
    public func getSelectedLanguage() -> Language {
        getSelectedLanguage_returnValue
    }
    
    public func getLanguageOptions() -> [Language] {
        getLanguageOptions_returnValue
    }
}
