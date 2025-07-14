//
//  DatabaseStub.swift
//  
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import SwiftData
import Foundation
import DBKitInterface

public protocol DatabaseStubbing {
    func set(_ response: DatabaseStub.StubResponse) async
}

public final actor DatabaseStub: DatabaseStubbing {
    public enum StubResponse: Sendable {
        case read(Result<[any PersistentModel & Sendable], Error>)
    }
    
    private var read_returnValue: Result<[any PersistentModel & Sendable], Error> = .failure(NSError(domain: "DatabaseStub", code: 0, userInfo: [NSLocalizedDescriptionKey: "Stub not set! "]))

    public init() {}

    public func set(_ response: StubResponse) async {
        switch response {
        case let .read(result):
            read_returnValue = result
        }
    }
}

extension DatabaseStub: DatabaseType {
    public func insert<Model: PersistentModel & Sendable>(_ model: Model) async {}
    
    public func delete<Model: PersistentModel & Sendable>(_ model: Model) async {}
    
    public func save() {}
    
    public func read<Element: PersistentModel & Sendable>(
        matching: Predicate<Element>?,
        sortBy: [SortDescriptor<Element>],
        limit: Int?
    ) async throws -> [Element]  {
        switch read_returnValue {
        case .success(let value):
            return value as! [Element]
        case .failure(let error):
            throw error
        }
    }
}
