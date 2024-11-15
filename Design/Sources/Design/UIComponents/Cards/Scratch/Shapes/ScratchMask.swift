//
//  ScratchMask.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//
import SwiftUI

struct ScratchMask: Shape {
    var strokes: [[CGPoint]]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for stroke in strokes {
            if let firstPoint = stroke.first {
                path.move(to: firstPoint)
                for point in stroke {
                    path.addLine(to: point)
                }
            }
        }
        return path
    }
}
