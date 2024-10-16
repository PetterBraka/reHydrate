//
//  HasLoggerService.swift
//
//
//  Created by Petter vang Brakalsvålet on 03/09/2023.
//

import LoggingKit

public protocol HasLoggerService {
    var logger: LoggerServicing { get set }
}
