//
//  BubblesView.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 7/5/24.
//

import SwiftUI

/// Single Bubble animted to move to top of the view
struct BubbleView: View {
    @State var bubble: BubbleViewModel

    var body: some View {
        Circle()
            .foregroundColor(bubble.color)
            .frame(width: bubble.width, height: bubble.height)
            .position(x: bubble.x, y: bubble.y)
            .onAppear {
                withAnimation(.linear(duration: bubble.lifetime)) {
                    bubble.y = 0  // Move to the top of the view
                    bubble.x += bubble.xFinalValue()  // Random x drift
                    let newSize = bubble.yFinalValue()
                    bubble.width = newSize
                    bubble.height = newSize
                }
            }
    }
}
