//
//  FibonaciCircleProgressLoaderView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//

import SwiftUI

struct FibonaciCircleProgressLoaderView: View {
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
                        .offset(getOffset(for: index, with: radius)) // Calculate the position of each circle
                        .scaleEffect(isAnimating ? 1 : 0.5) // Dynamic scaling effect
                        .animation(
                            Animation.easeInOut(duration: 1.2) // Single animation cycle
                                .delay(0.1 * Double(index)), // Delay for each circle
                            value: isAnimating // Link with the state
                        )
                }
                
                Text("Loading...")
                    .font(.headline)
                    .offset(y: 50) // Slightly move below the animations
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            startAnimation() // Start animation when the view appears
        }
    }
    
    // Function to calculate the radial offset of each circle
    private func getOffset(for index: Int, with radius: CGFloat) -> CGSize {
        let angle = Double(index) * (360.0 / 15.0) // Divide 360° among 15 circles
        let currentRadius: CGFloat = isAnimating ? radius : 0 // Dynamic radius (expand and contract)
        return CGSize(
            width: cos(angle * .pi / 180) * currentRadius,
            height: sin(angle * .pi / 180) * currentRadius
        )
    }
    
    // Function to control the animation
    private func startAnimation() {
        // Restart the cycle after the animation
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            withAnimation {
                isAnimating.toggle() // Toggle the state to restart the animation
            }
        }
    }
}

#Preview {
    FibonaciCircleProgressLoaderView()
}
