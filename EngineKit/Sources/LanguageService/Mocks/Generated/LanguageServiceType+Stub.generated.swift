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
    public var getSelectedLanguage_returnValue: Language {
        get {
            if getSelectedLanguage_returnValues.count > 1 {
                getSelectedLanguage_returnValues.removeFirst()
            } else {
                getSelectedLanguage_returnValues.first ?? .default
            }
        }
        set {
            getSelectedLanguage_returnValues.append(newValue)
        }
    }
    private var getSelectedLanguage_returnValues: [Language] = []
    public var getLanguageOptions_returnValue: [Language] {
        get {
            if getLanguageOptions_returnValues.count > 1 {
                getLanguageOptions_returnValues.removeFirst()
            } else {
                getLanguageOptions_returnValues.first ?? .default
            }
        }
        set {
            getLanguageOptions_returnValues.append(newValue)
        }
    }
    private var getLanguageOptions_returnValues: [[Language]] = []

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
