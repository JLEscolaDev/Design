//
//  VariableOrientationStack.swift
//  Design
//
//  Created by Jose Luis Escolá García on 12/11/24.
//

import SwiftUI

struct VariableOrientationStack<Content: View>: View {
    private let orientation: Orientation
    private let content: () -> Content
    
    init(orientation: Orientation = .vertical, @ViewBuilder content: @escaping () -> Content) {
        self.orientation = orientation
        self.content = content
    }
    
    var body: some View {
        switch orientation {
            case .vertical:
                VStack(alignment: .center, spacing: 0) {
                    content()
                }
            case .horizontal:
                HStack(alignment: .center, spacing: 0) {
                    content()
                }
        }
    }
}

#Preview {
    VariableOrientationStack(orientation: .horizontal) {
        Color.red
        Color.yellow
    }
}
