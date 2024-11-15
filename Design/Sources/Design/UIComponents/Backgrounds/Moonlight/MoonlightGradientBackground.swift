//
//  MoonlightGradientBackground.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//
import SwiftUI

public struct MoonlightGradientBackground: View {
    public init() {}
    
    @State private var animate = false
    
    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 200, height: 200)
                    .offset(x: animate ? -100 : 100, y: animate ? -200 : 200)
                
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 250, height: 250)
                    .offset(x: animate ? 150 : -150, y: animate ? 100 : -100)
                
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 300, height: 300)
                    .offset(x: animate ? -150 : 150, y: animate ? -250 : 250)
                
                Circle()
                    .fill(Color.cyan.opacity(0.3))
                    .frame(width: 400, height: 400)
                    .offset(x: animate ? 200 : -200, y: animate ? -300 : 300)
                
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 350, height: 350)
                    .offset(x: animate ? -250 : 250, y: animate ? 250 : -250)
            }
            .blur(radius: 120)
            .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
            .onAppear {
                animate = true
            }
        }
    }
}

#Preview {
    MoonlightGradientBackground()
}
