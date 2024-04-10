// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import LanguageServiceInterface

public protocol LanguageServiceTypeSpying {
    var variableLog: [LanguageServiceTypeSpy.VariableName] { get set }
    var lastvariabelCall: LanguageServiceTypeSpy.VariableName? { get }
    var methodLog: [LanguageServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: LanguageServiceTypeSpy.MethodCall? { get }
}

public final class LanguageServiceTypeSpy: LanguageServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case setLanguage(language: Language)
        case getSelectedLanguage
        case getLanguageOptions
    }

    public var variableLog: [VariableName] = []
    public var lastvariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private let realObject: LanguageServiceType
    public init(realObject: LanguageServiceType) {
        self.realObject = realObject
    }
}

extension LanguageServiceTypeSpy: LanguageServiceType {
    public func setLanguage(to language: Language) -> Void {
        methodLog.append(.setLanguage(language: language))
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
