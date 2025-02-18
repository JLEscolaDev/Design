//
//  Particle.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/11/24.
//
import SwiftUI

public struct Particle: Identifiable, Equatable {
    public let id = UUID()
    let color: Color = [Color.yellow, Color.orange, Color.pink, Color.purple, Color.blue].randomElement() ?? .blue
    let size: CGFloat = CGFloat.random(in: 5...15)
    let position: CGPoint = CGPoint(x: CGFloat.random(in: 0...MultiplatformScreen.bounds.width), y: CGFloat.random(in: 0...100))
    let lifetime: Double = Double.random(in: 0.5...1.5)
    let opacity: Double = Double.random(in: 0.5...1.0)
}
