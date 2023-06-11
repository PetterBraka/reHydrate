//
//  RouterObservable.swift
//  
//
//  Created by Petter vang Brakalsvålet on 11/06/2023.
//

import Foundation

public protocol RouterObservableType: AnyObject {
    func setTab(to tab: Tab)
}

public final class RouterObservable: RouterObservableType, ObservableObject {
    let router: Router
    @Published public var tab: Tab = .home
    
    public init(router: Router, tab: Tab) {
        self.router = router
        self.tab = tab
    }
    
    public func setTab(to tab: Tab) {
        self.tab = tab
    }
}
