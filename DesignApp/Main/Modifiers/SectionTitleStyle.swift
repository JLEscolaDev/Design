//
//  SectionTitleStyle.swift
//  DesignApp
//
//  Created by Jose Luis Escolá García on 30/10/24.
//

import SwiftUI

struct SectionTitleStyle: ViewModifier {
    let colorScheme: ColorScheme
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(colorScheme == .light ? .white : .black)
    }
}

extension View {
    
    func sectionTitleStyle(_ colorScheme: ColorScheme = .light) -> some View {
        self.modifier(SectionTitleStyle(colorScheme: colorScheme))
    }
}
