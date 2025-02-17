//
//  DirtParticle.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//
import SwiftUI

struct DirtParticle {
    var position: CGPoint
    var shape: Path
    var color: Color
    
    init(position: CGPoint, color: Color) {
        self.position = position
        self.shape = DirtParticle.generateRandomPath(at: position)
        self.color = color
    }

    static func generateRandomPath(at point: CGPoint) -> Path {
        var path = Path()
        let numberOfPoints = Int.random(in: 3...6)
        var points: [CGPoint] = []
        
        for _ in 0..<numberOfPoints {
            let randomXOffset = CGFloat.random(in: -5...5)
            let randomYOffset = CGFloat.random(in: -5...5)
            let newPoint = CGPoint(x: point.x + randomXOffset, y: point.y + randomYOffset)
            points.append(newPoint)
        }
        
        path.move(to: points[0])
        
        for point in points {
            path.addLine(to: point)
        }
        
        path.closeSubpath()
        
        return path
    }
}
