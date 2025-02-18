//
//  DayNightToggleBackground.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//


import SwiftUI

#if os(macOS)
import AppKit
#endif

struct DayNightToggleBackground: View {
    @Binding var isDay: Bool
    @State private var animate = false
    @State private var rayWidth: CGFloat = 10
    @State private var rayBlur: CGFloat = 0
    @State private var sunOpacity: Double = 0
    @State private var sunPositionY: CGFloat = 0
    @State private var sunSize: CGFloat = 50

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: isDay
                                       ? [.blue, .blue, .cyan, .blue.opacity(0.4)]
                                       : [.black, .blue.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Night/fireflies effect
                if !isDay {
                    nightCircles(geo: geo)
                }

                // beam of light
                if isDay {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: rayWidth, height: geo.size.height)
                        .blur(radius: rayBlur)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2)) {
                                rayWidth = geo.size.width * 1.5
                                rayBlur = geo.size.width * 0.02
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeInOut(duration: 1)) {
                                    sunPositionY = geo.size.height * 0.9
                                }
                            }
                            withAnimation(.easeInOut(duration: 2)) {
                                sunOpacity = 1
                                sunSize = geo.size.width * 0.3
                            }
                        }
                }

                // Sun (animated from bottom - out of bounds)
                if isDay {
                    Circle()
                        .fill(Color.yellow.opacity(0.7))
                        .frame(width: sunSize, height: sunSize)
                        .blur(radius: geo.size.width * 0.05)
                        .position(x: geo.size.width * 0.5, y: sunPositionY)
                        .opacity(sunOpacity)
                }
            }
            .onAppear {
                animate = true
                sunSize = geo.size.width * 0.3
                sunPositionY = geo.size.height + sunSize / 2
            }
            .onChange(of: isDay) { _, _ in
                animate.toggle()
                if !isDay {
                    // Resetea valores al volver a la noche
                    withAnimation(.easeInOut(duration: 2)) {
                        rayWidth = 10
                        rayBlur = 0
                        sunOpacity = 0
                        sunPositionY = geo.size.height + sunSize / 2
                        sunSize = geo.size.width * 0.1
                    }
                }
            }
        }
    }
    
    // 🌙 Night fireflies
    func nightCircles(geo: GeometryProxy) -> some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.8))
                .frame(width: geo.size.width * 0.2, height: geo.size.width * 0.2)
                .offset(
                    x: animate ? -geo.size.width * 0.1 : geo.size.width * 0.1,
                    y: animate ? -geo.size.height * 0.2 : geo.size.height * 0.2
                )

            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                .offset(
                    x: animate ? geo.size.width * 0.15 : -geo.size.width * 0.15,
                    y: animate ? geo.size.height * 0.1 : -geo.size.height * 0.1
                )

            Circle()
                .fill(Color.purple.opacity(0.2))
                .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.3)
                .offset(
                    x: animate ? -geo.size.width * 0.15 : geo.size.width * 0.15,
                    y: animate ? -geo.size.height * 0.25 : geo.size.height * 0.25
                )

            Circle()
                .fill(Color.cyan.opacity(0.3))
                .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.4)
                .offset(
                    x: animate ? geo.size.width * 0.2 : -geo.size.width * 0.2,
                    y: animate ? -geo.size.height * 0.3 : geo.size.height * 0.3
                )

            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.35)
                .offset(
                    x: animate ? -geo.size.width * 0.25 : geo.size.width * 0.25,
                    y: animate ? geo.size.height * 0.25 : -geo.size.height * 0.25
                )
        }
        .blur(radius: geo.size.width * 0.1)
        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
    }
}

// MARK: - PREVIEW

#Preview {
    @State var isDay: Bool = false
    DayNightToggleBackground(isDay: $isDay)
}
