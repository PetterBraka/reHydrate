//
//  View+if.swift
//
//
//  Created by Petter vang Brakalsvålet on 16/12/2023.
//

import SwiftUI

extension View {
    @ViewBuilder 
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content,
        elseTransform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
    
    @ViewBuilder
    func `if`<Content: View, Value: Any>(
        _ optional: Value?,
        transform: (Self, Value) -> Content
    ) -> some View {
        if let optional {
            transform(self, optional)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<Content: View, Value: Any>(
        _ optional: Value?,
        transform: (Self, Value) -> Content,
        elseTransform: (Self) -> Content
    ) -> some View {
        if let optional {
            transform(self, optional)
        } else {
            elseTransform(self)
        }
    }
}
