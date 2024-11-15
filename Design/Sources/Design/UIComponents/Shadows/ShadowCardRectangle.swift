//
//  ShadowCardRectangle.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//

import SwiftUI

struct ShadowCardRectangle: View {
    var color: Color = Color.white
    var radius: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            RoundedRectangle(cornerRadius: radius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [color, color.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RadialGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.02), Color.black.opacity(0.03), Color.black.opacity(0.1)]),
                        center: .center,
                        startRadius: size*0.25,
                        endRadius: geometry.size.width / 2
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: radius)
                            .inset(by: size*0.02)
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}

struct BottomShadowCardRectangle: View {
    var color: Color = Color.white
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            RoundedRectangle(cornerRadius: size*0.08)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [color, color.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.02), Color.black.opacity(0.03), Color.black.opacity(0.1)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: size*0.08)
                            .inset(by: size*0.02)
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}


#Preview {
    ShadowCardRectangle()
}

#Preview {
    BottomShadowCardRectangle()
}



