//
//  FireflyView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//
import SwiftUI

struct FireflyView: View {
    @State var firefly: Firefly
    
    var body: some View {
        Circle()
            .fill(Color.yellow.opacity(0.8))
            .frame(width: firefly.size, height: firefly.size)
            .blur(radius: Double.random(in: 2...8))  // Aplicamos desenfoque para suavizar las luces
            .opacity(firefly.opacity)
            .position(x: firefly.xPosition, y: firefly.yPosition)
    }
}
