//
//  ParticleEffectView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/11/24.
//
import SwiftUI

// MARK: - Particle Effect View

struct ParticleEffectView: View {
    @State private var particles: [Particle] = []
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .animation(.easeOut(duration: particle.lifetime), value: particle.position)
            }
        }

        .onAppear {
            generateParticles()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func generateParticles() {
            // Generate particle explotion
            let particleCount = 30
            particles = (0..<particleCount).map { _ in Particle() }
        }
}
