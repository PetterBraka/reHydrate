//
//  MainAssembler.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 15/11/2021.
//  Copyright © 2021 Petter vang Brakalsvålet. All rights reserved.
//

import Foundation
import Swinject

final class MainAssembler {
    public static let shared = MainAssembler()

    let container: Container
    private let assembler: Assembler

    private init() {
        container = Container()
        assembler = Assembler([ViewModelAssembler(), ManagerAssembly()],
                              container: container)
    }
}
