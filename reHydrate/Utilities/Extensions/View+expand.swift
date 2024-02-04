//
//  View+expand.swift
//  reHydrate
//
//  Created by Petter vang Brakalsvålet on 27/01/2024.
//  Copyright © 2024 Petter vang Brakalsvålet. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func expandVH(vAlignment: VerticalAlignment = .center, hAlignment: HorizontalAlignment = .center) -> some View {
        self
            .expandV(alignment: hAlignment)
            .expandH(alignment: vAlignment)
    }
    
    @ViewBuilder
    func expandV(alignment: HorizontalAlignment = .center) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            Spacer()
            self
            Spacer()
        }
    }
    
    @ViewBuilder
    func expandH(alignment: VerticalAlignment = .center) -> some View {
        HStack(alignment: alignment, spacing: 0) {
            Spacer()
            self
            Spacer()
        }
    }
}
