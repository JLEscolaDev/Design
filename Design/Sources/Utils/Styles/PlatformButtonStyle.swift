//
//  PlatformButtonStyle.swift
//  Design
//
//  Created by Jose Luis Escolá García on 19/2/25.
//


import SwiftUI

struct PlatformButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .buttonStyle(.plain)
            .focusable(false)
        #else
        content
        #endif
    }
}

extension View {
    func multiplatformButton() -> some View {
        self.modifier(PlatformButtonStyle())
    }
}
