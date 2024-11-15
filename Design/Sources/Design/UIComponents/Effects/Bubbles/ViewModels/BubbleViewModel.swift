//
//  BubblesViewModel.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 7/5/24.
//

import SwiftUI

@Observable
class BubbleViewModel: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color
    var width: CGFloat
    var height: CGFloat
    var lifetime: TimeInterval

    init(height: CGFloat, width: CGFloat, x: CGFloat, y: CGFloat, color: Color, lifetime: TimeInterval) {
        self.height = height
        self.width = width
        self.color = color
        self.x = x
        self.y = y
        self.lifetime = lifetime
    }

    func xFinalValue() -> CGFloat {
        CGFloat.random(in: -width...width)
    }

    func yFinalValue() -> CGFloat {
        CGFloat.random(in: 0...height)
    }
}
