//
//  OpenUrlServiceInterface.swift
//
//
//  Created by Petter vang Brakalsvålet on 02/11/2023.
//

import Foundation

public protocol OpenUrlServiceInterface {
    var settingsUrl: URL? { get }
    
    func open(url: URL) async
}

public protocol HasOpenUrlService {
    var openUrlService: OpenUrlServiceInterface { get set }
}
