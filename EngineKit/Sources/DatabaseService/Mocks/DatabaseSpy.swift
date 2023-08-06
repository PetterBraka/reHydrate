//
//  DatabaseSpy.swift
//  
//
//  Created by Petter vang Brakalsvålet on 06/08/2023.
//

import Blackbird
import DatabaseServiceInterface
import Foundation

public final class DatabaseStub: DatabaseType {
    public var db: Blackbird.Database?
    
    public func write<Element: BlackbirdModel>(_ element: Element) {}

    var givenRead: Array<(any BlackbirdModel)> = []
    public func read<Element: BlackbirdModel>(
        matching: BlackbirdModelColumnExpression<Element>?,
        orderBy: BlackbirdModelOrderClause<Element>,
        limit: Int?
    ) -> [Element] {
        givenRead
            .map { given -> Element in
                return given as! Element
            }
    }

    public func delete<Element: BlackbirdModel>(_ element: Element) {}

    public func delete<Element: BlackbirdModel>(matching: BlackbirdModelColumnExpression<Element>) {}
}

public final class DatabaseSpy: DatabaseType {
    public var db: Blackbird.Database?
    
    public init() {}
    
    var invokedWrite = false
    var invokedWriteCount = 0
    var invokedWriteParameters: (element: Any, Void)?
    var invokedWriteParametersList = [(element: Any, Void)]()

    public func write<Element: BlackbirdModel>(_ element: Element) {
        invokedWrite = true
        invokedWriteCount += 1
        invokedWriteParameters = (element, ())
        invokedWriteParametersList.append((element, ()))
    }

    var invokedRead = false
    var invokedReadCount = 0
    var invokedReadParameters: (matching: Any?,
                                orderBy: Any,
                                limit: Int?)?
    var invokedReadParametersList: [(matching: Any?,
                                     orderBy: Any,
                                     limit: Int?)] = []

    public func read<Element: BlackbirdModel>(
        matching: BlackbirdModelColumnExpression<Element>?,
        orderBy: BlackbirdModelOrderClause<Element>,
        limit: Int?
    ) -> [Element] {
        invokedRead = true
        invokedReadCount += 1
        invokedReadParameters = (matching, orderBy, limit)
        invokedReadParametersList.append((matching, orderBy, limit))
        return []
    }

    var invokedDeleteElement = false
    var invokedDeleteElementCount = 0
    var invokedDeleteElementParameters: (element: Any, Void)?
    var invokedDeleteElementParametersList = [(element: Any, Void)]()

    public func delete<Element: BlackbirdModel>(_ element: Element) {
        invokedDeleteElement = true
        invokedDeleteElementCount += 1
        invokedDeleteElementParameters = (element, ())
        invokedDeleteElementParametersList.append((element, ()))
    }

    var invokedDeleteMatching = false
    var invokedDeleteMatchingCount = 0
    var invokedDeleteMatchingParameters: (matching: Any, Void)?
    var invokedDeleteMatchingParametersList = [(matching: Any, Void)]()

    public func delete<Element: BlackbirdModel>(matching: BlackbirdModelColumnExpression<Element>) {
        invokedDeleteMatching = true
        invokedDeleteMatchingCount += 1
        invokedDeleteMatchingParameters = (matching, ())
        invokedDeleteMatchingParametersList.append((matching, ()))
    }
}
