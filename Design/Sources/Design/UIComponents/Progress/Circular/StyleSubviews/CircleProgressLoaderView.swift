//
//  CircleProgressLoaderView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//

import SwiftUI

struct CircleProgressLoaderView: View {
    @State private var isAnimating = false
    var circleSize: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.height, geometry.size.width) / 2 - circleSize
            ZStack {
                // ForEach to create the circles
                ForEach(0..<15) { index in
                    Circle()
                        .frame(width: circleSize, height: circleSize) // Circle size
                        .scaleEffect(isAnimating ? 0.4 : 1.0) // Animation effect for scaling
                        .offset(CGSize(width: 0, height: -radius)) // Calculate the position of each circle
                        .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center) // Circular rotation
                        .animation(
                            Animation.linear(duration: 4.35) // Fixed duration for each circle
                                .repeatForever(autoreverses: false) // Infinite animation loop
                                .delay(0.29 * Double(index)), // Incremental delay per circle
                            value: isAnimating
                        )
                }
                
                Text("Loading...")
                    .font(.headline)
                    .offset(y: 50) // Slightly move below the animation
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // Match parent size
        }
        .onAppear {
            isAnimating = true // Start animation when the view appears
        }
    }
}

#Preview {
    CircleProgressLoaderView()
}
