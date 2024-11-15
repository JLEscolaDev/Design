//
//  Firefly.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//
import SwiftUI

// Struct para representar las propiedades de cada luciérnaga
@Observable
class Firefly: Identifiable {
    let id = UUID()
    var xPosition: CGFloat
    var yPosition: CGFloat
    let size: CGFloat
    let opacity: Double
    let animationDuration: Double
    
    init(xPosition: CGFloat, yPosition: CGFloat, size: CGFloat, opacity: Double, animationDuration: Double) {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.size = size
        self.opacity = opacity
        self.animationDuration = animationDuration
        startMovement()
    }
    
    // Movimiento aleatorio continuo de las luciérnagas
    func startMovement() {
        withAnimation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
            // Genera un nuevo punto de destino aleatorio
            xPosition += CGFloat.random(in: -50...50)
            yPosition += CGFloat.random(in: -30...30)
        }
        
        // Actualiza la posición de la luciérnaga de manera continua con un delay aleatorio
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.startMovement() // Llamada recursiva para mantener el movimiento
        }
    }
}
