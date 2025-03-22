// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - AutoSpy
// swiftlint:disable all

import Foundation
import LanguageServiceInterface

public protocol LanguageServiceTypeSpying {
    var variableLog: [LanguageServiceTypeSpy.VariableName] { get set }
    var lastVariabelCall: LanguageServiceTypeSpy.VariableName? { get }
    var methodLog: [LanguageServiceTypeSpy.MethodCall] { get set }
    var lastMethodCall: LanguageServiceTypeSpy.MethodCall? { get }
}

public final class LanguageServiceTypeSpy: LanguageServiceTypeSpying {
    public enum VariableName {
    }

    public enum MethodCall {
        case setLanguageLanguage(language: Language)
        case getSelectedLanguage
        case getLanguageOptions
    }

    public var variableLog: [VariableName] = []
    public var lastVariabelCall: VariableName? { variableLog.last }
    public var methodLog: [MethodCall] = []
    public var lastMethodCall: MethodCall? { methodLog.last }
    private var realObject: LanguageServiceType
    public init(realObject: LanguageServiceType) {
        self.realObject = realObject
    }
}

extension LanguageServiceTypeSpy: LanguageServiceType {
    public func setLanguage(to language: Language) -> Void {
        methodLog.append(.setLanguageLanguage(language: language))
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

extension LanguageServiceTypeSpy.VariableName: CustomStringConvertible {
    public var description: String {
        switch self {
        }
    }
}

extension LanguageServiceTypeSpy.MethodCall: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setLanguageLanguage(let language): "setLanguage(\(String(describing: language)))"
        case .getSelectedLanguage: "getSelectedLanguage("
        case .getLanguageOptions: "getLanguageOptions("
        }
    }
}
// MARK: - AutoString
// swiftlint:disable all

import LanguageServiceInterface


// MARK: - AutoStub
// swiftlint:disable all  
import Foundation
import LanguageServiceInterface

public protocol LanguageServiceTypeStubbing {
    var getSelectedLanguage_returnValue: Language { get set }
    var getLanguageOptions_returnValue: [Language] { get set }
}

public final class LanguageServiceTypeStub: LanguageServiceTypeStubbing {
    public var getSelectedLanguage_returnValue: Language {
        get {
            if getSelectedLanguage_returnValues.isEmpty {
                .default
            } else {
                getSelectedLanguage_returnValues.removeFirst()
            }
        }
        set {
            getSelectedLanguage_returnValues.append(newValue)
        }
    }
    private var getSelectedLanguage_returnValues: [Language] = []
    public var getLanguageOptions_returnValue: [Language] {
        get {
            if getLanguageOptions_returnValues.isEmpty {
                .default
            } else {
                getLanguageOptions_returnValues.removeFirst()
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
