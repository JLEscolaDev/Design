//
//  ExplotionCircleProgressLoaderView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//


import SwiftUI

struct ExplotionCircleProgressLoaderView: View {
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // ForEach to create multiple animated circles
                ForEach(0..<5) { index in
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [4, 20]))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .scaleEffect(isLoading ? 1 : 0) // Animate scaling
                        .opacity(isLoading ? 1 : 0) // Animate opacity for better effect
                        .animation(
                            Animation.easeOut(duration: 1.0)
                                .delay(0.1 * Double(index)) // Incremental delay for each circle
                                .repeatForever(autoreverses: false), // Infinite animation loop
                            value: isLoading
                        )
                }
                
                Text("Loading...")
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // Match parent size
        }
        .onAppear {
            isLoading = true // Start animation when the view appears
        }
    }
}

#Preview {
    ExplotionCircleProgressLoaderView()
}
