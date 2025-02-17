//
//  SpaceBackground.swift
//  Design
//
//  Created by Jose Luis Escolá García on 17/2/25.
//


import SwiftUI

public struct SpaceBackground: View {
    private let starCount = 50
    @State private var stars: [Star] = []

    public init() {
        var temp: [Star] = []
        for _ in 0..<starCount {
            temp.append(
                Star(
                    x: Double.random(in: 0...1),
                    y: Double.random(in: 0...1),
                    size: Double.random(in: 2...5),
                    glowSize: Double.random(in: 10...25), // Tamaño del resplandor
                    baseOpacity: Double.random(in: 0.2...0.5),
                    targetOpacity: Double.random(in: 0.6...1.0),
                    animationDuration: Double.random(in: 2...6),
                    color: [Color.white, Color.cyan, Color.blue.opacity(0.8)].randomElement()!
                )
            )
        }
        _stars = State(initialValue: temp)
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                // Fondo oscuro con gradiente sutil
                LinearGradient(
                    gradient: Gradient(colors: [
                        .black,
                        Color(red: 0.0, green: 0.02, blue: 0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Renderizado de estrellas
                ForEach(stars) { star in
                    StarView(star: star)
                        .position(
                            x: star.x * proxy.size.width,
                            y: star.y * proxy.size.height
                        )
                }
            }
            .ignoresSafeArea()
        }
    }
}

fileprivate struct Star: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
    let size: Double
    let glowSize: Double
    let baseOpacity: Double
    let targetOpacity: Double
    let animationDuration: Double
    let color: Color
}

fileprivate struct StarView: View {
    let star: Star
    @State private var currentOpacity: Double = 1.0

    var body: some View {
        ZStack {
            // Capa de luz difusa con desenfoque
            Circle()
                .fill(star.color)
                .frame(width: star.glowSize, height: star.glowSize)
                .blur(radius: star.glowSize / 2)
                .opacity(currentOpacity * 0.4) // Opacidad reducida para el halo
                .blendMode(.plusLighter)

            // Estrella principal
            Circle()
                .fill(star.color)
                .frame(width: star.size, height: star.size)
                .shadow(color: star.color.opacity(0.6), radius: 8) // Sombra externa
                .opacity(currentOpacity)
        }
        .onAppear {
            currentOpacity = star.baseOpacity
            withAnimation(
                .easeInOut(duration: star.animationDuration)
                .repeatForever(autoreverses: true)
            ) {
                currentOpacity = star.targetOpacity
            }
        }
    }
}

#Preview {
    SpaceBackground()
}
