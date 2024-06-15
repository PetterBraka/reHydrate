//
//  HasService.swift
//
//
//  Created by Petter vang Brakalsvålet on 06/05/2024.
//

public protocol HasPhoneService {
    var phoneService: PhoneServiceType { get set }
}

public protocol HasWatchService {
    var watchService: WatchServiceType { get set }
}
