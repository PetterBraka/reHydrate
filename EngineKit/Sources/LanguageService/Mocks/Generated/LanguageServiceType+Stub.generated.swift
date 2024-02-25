// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name    
import Foundation
import LanguageServiceInterface

public protocol LanguageServiceTypeStubbing {
    var getSelectedLanguage_returnValue: Language { get set }
    var getLanguageOptions_returnValue: [Language] { get set }
}

public final class LanguageServiceTypeStub: LanguageServiceTypeStubbing {
    public var getSelectedLanguage_returnValue: Language = .default
    public var getLanguageOptions_returnValue: [Language] = .default

    public init() {}
}

extension LanguageServiceTypeStub: LanguageServiceType {
    public func setLanguage(to language: Language) -> Void {
    }

    public func getSelectedLanguage() -> Language {
        getSelectedLanguage_returnValue
    }

    public func getLanguageOptions() -> [Language] {
        getLanguageOptions_returnValue
    }

}
