// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import LanguageServiceInterface

public protocol LanguageServiceTypeSpying {
    var variableLog: [LanguageServiceTypeSpy.VariableName] { get set }
    var methodLog: [LanguageServiceTypeSpy.MethodName] { get set }
}

public final class LanguageServiceTypeSpy: LanguageServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodName {
            case setLanguage_to
            case getSelectedLanguage
            case getLanguageOptions
    }

    public var variableLog: [VariableName] = []
    public var methodLog: [MethodName] = []
    private let realObject: LanguageServiceType
    public init(realObject: LanguageServiceType) {
        self.realObject = realObject
    }
}

extension LanguageServiceTypeSpy: LanguageServiceType {
    public func setLanguage(to language: Language) -> Void {
        methodLog.append(.setLanguage_to)
        realObject.setLanguage(to: language)
    }
    public func getSelectedLanguage() -> Language {
        methodLog.append(.getSelectedLanguage)
        return realObject.getSelectedLanguage()
    }
    public func getLanguageOptions() -> [Language] {
        methodLog.append(.getLanguageOptions)
        return realObject.getLanguageOptions()
    }
}
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

