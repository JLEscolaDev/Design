//
//  DayNightToggleBackground.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//


import SwiftUI

struct DayNightToggleBackground: View {
    @Binding var isDay: Bool
    @State private var animate = false
    @State private var rayWidth: CGFloat = 10
    @State private var rayBlur: CGFloat = 0
    @State private var sunOpacity: Double = 0
    @State private var sunPositionY: CGFloat = UIScreen.main.bounds.height / 1.5
    @State private var sunSize: CGFloat = 50

    var body: some View {
        ZStack {
            // Background gradient that changes from night to day
            LinearGradient(
                gradient: Gradient(colors: isDay ? [Color(.blue),Color(.blue), Color.cyan, Color.black.opacity(0.1)] : [Color.black, Color.blue.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Animated circles for moonlight effect (visible only at night)
            if !isDay {
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
            }

            // Light ray effect during "sunrise" (only visible in day mode)
            if isDay {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: rayWidth, height: UIScreen.main.bounds.height)
                    .blur(radius: rayBlur)
                    .animation(.easeInOut(duration: 2), value: rayWidth)
                    .onAppear {
                        // Animate the ray expanding
                        withAnimation(.easeInOut(duration: 2)) {
                            rayWidth = UIScreen.main.bounds.width * 1.5
                            rayBlur = 20
                        }
                        // Delay for the sun to appear and animate after ray expansion
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 1)) {
                                sunPositionY = UIScreen.main.bounds.height / 2.1
                            }
                        }
                        withAnimation(.easeInOut(duration: 2)) {
                            sunOpacity = 1
                            sunSize = 300
                        }
                    }
            }

            // Sun (semi-circle with blur) at the bottom during "day"
            if isDay {
                Circle()
                    .fill(Color.yellow.opacity(0.7))
                    .frame(width: sunSize, height: sunSize)
                    .blur(radius: 30)
                    .offset(y: sunPositionY)
                    .opacity(sunOpacity)
                    .animation(.easeInOut(duration: 2), value: sunOpacity)
            }
        }
        .onAppear {
            animate = true
        }
        .onChange(of: isDay) { newValue in
            animate.toggle()
            
            // Reset animations for ray and sun when switching to night
            if !isDay {
                withAnimation(.easeInOut(duration: 2)) {
                    rayWidth = 10
                    rayBlur = 0
                    sunOpacity = 0
                    sunPositionY = UIScreen.main.bounds.height
                    sunSize = 50
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isDay: Bool = false
    DayNightToggleBackground(isDay: $isDay)
}
