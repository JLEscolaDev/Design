//
//  CircularProgressLoader.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//

import SwiftUI

public struct CircularProgressLoader: View {
    @State private var isAnimating = false
    let style: CircularLoaderStyle
    
    public init(style: CircularLoaderStyle) {
        self.style = style
    }
    
    public var body: some View {
        switch style {
            case .expandingCircles:
                ExplotionCircleProgressLoaderView()
                
            case .rotatingDots:
                CircleProgressLoaderView()
                
            case .radialMovement:
                FibonaciCircleProgressLoaderView()
        }
    }
}

extension CircularProgressLoader {
    public static var preview: some View {
        VStack(spacing: 30) {
            CircularProgressLoader(style: .expandingCircles)
                .foregroundColor(.green)
                .frame(width: 100, height: 100)
            CircularProgressLoader(style: .rotatingDots)
                .foregroundColor(.red)
                .frame(width: 200, height: 200)
            CircularProgressLoader(style: .radialMovement)
                .foregroundColor(.cyan)
                .frame(width: 200, height: 200)
        }
    }
}

#Preview {
    CircularProgressLoader.preview
}
