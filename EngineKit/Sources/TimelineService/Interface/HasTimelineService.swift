//
//  HasTimelineService.swift
//
//
//  Created by Petter vang Brakalsvålet on 12/08/2023.
//

import Foundation

public protocol HasTimelineService {
    var timelineService: TimelineServiceType { get set }
}
