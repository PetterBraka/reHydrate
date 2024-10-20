//
//  DummyModel.swift
//
//
//  Created by Petter vang Brakalsvålet on 10/08/2023.
//

import CoreData

public final class DummyModel: NSManagedObject, @unchecked Sendable {
    public var id: String = ""
    public var text: String = ""
}
