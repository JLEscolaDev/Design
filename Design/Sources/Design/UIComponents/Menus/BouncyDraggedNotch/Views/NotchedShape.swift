//
//  NotchedShape.swift
//  Design
//
//  Created by Jose Luis Escolá García on 29/11/24.
//

import SwiftUI

struct NotchedShape: Shape {
    var deformation: CGFloat // Profundidad de la muesca
    var notchLengthMultiplier: CGFloat // Profundidad de la muesca
    var notchPosition: CGFloat // Posición de la muesca (horizontal o vertical)
    var side: NotchPosition // Lado de la muesca

    // Animamos tanto la deformación como la posición de la muesca
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(deformation, notchPosition) }
        set {
            deformation = newValue.first
            notchPosition = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Dimensiones de la muesca
        let notchSize = deformation // Tamaño de la muesca (ancho o alto, dependiendo del lado)
        let notchLength = (side == .left || side == .right) ? rect.height * notchLengthMultiplier : rect.width * notchLengthMultiplier
        let cornerRadius = min(deformation * 0.7, notchSize / 2, notchLength / 2) // Aseguramos que el radio no exceda los límites

        switch side {
        case .left:
            // Lógica para la muesca en el lado izquierdo
            let notchY = max(rect.minY + notchLength / 2, min(notchPosition, rect.maxY - notchLength / 2))
            let notchStartY = notchY - notchLength / 2
            let notchEndY = notchY + notchLength / 2

            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: notchStartY - cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + cornerRadius, y: notchStartY),
                control: CGPoint(x: rect.minX, y: notchStartY)
            )
            path.addLine(to: CGPoint(x: rect.minX + notchSize - cornerRadius, y: notchStartY))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + notchSize, y: notchStartY + cornerRadius),
                control: CGPoint(x: rect.minX + notchSize, y: notchStartY)
            )
            path.addLine(to: CGPoint(x: rect.minX + notchSize, y: notchEndY - cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + notchSize - cornerRadius, y: notchEndY),
                control: CGPoint(x: rect.minX + notchSize, y: notchEndY)
            )
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: notchEndY))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX, y: notchEndY + cornerRadius),
                control: CGPoint(x: rect.minX, y: notchEndY)
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.closeSubpath()

        case .right:
            // Lógica para la muesca en el lado derecho
            let notchY = max(rect.minY + notchLength / 2, min(notchPosition, rect.maxY - notchLength / 2))
            let notchStartY = notchY - notchLength / 2
            let notchEndY = notchY + notchLength / 2

            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: notchStartY - cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - cornerRadius, y: notchStartY),
                control: CGPoint(x: rect.maxX, y: notchStartY)
            )
            path.addLine(to: CGPoint(x: rect.maxX - notchSize + cornerRadius, y: notchStartY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - notchSize, y: notchStartY + cornerRadius),
                control: CGPoint(x: rect.maxX - notchSize, y: notchStartY)
            )
            path.addLine(to: CGPoint(x: rect.maxX - notchSize, y: notchEndY - cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - notchSize + cornerRadius, y: notchEndY),
                control: CGPoint(x: rect.maxX - notchSize, y: notchEndY)
            )
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: notchEndY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: notchEndY + cornerRadius),
                control: CGPoint(x: rect.maxX, y: notchEndY)
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.closeSubpath()

        case .top:
            // Lógica para la muesca en la parte superior
            let notchX = max(rect.minX + notchLength / 2, min(notchPosition, rect.maxX - notchLength / 2))
            let notchStartX = notchX - notchLength / 2
            let notchEndX = notchX + notchLength / 2

            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: notchStartX - cornerRadius, y: rect.minY))
            path.addQuadCurve(
                to: CGPoint(x: notchStartX, y: rect.minY + cornerRadius),
                control: CGPoint(x: notchStartX, y: rect.minY)
            )
            path.addLine(to: CGPoint(x: notchStartX, y: rect.minY + notchSize - cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: notchStartX + cornerRadius, y: rect.minY + notchSize),
                control: CGPoint(x: notchStartX, y: rect.minY + notchSize)
            )
            path.addLine(to: CGPoint(x: notchEndX - cornerRadius, y: rect.minY + notchSize))
            path.addQuadCurve(
                to: CGPoint(x: notchEndX, y: rect.minY + notchSize - cornerRadius),
                control: CGPoint(x: notchEndX, y: rect.minY + notchSize)
            )
            path.addLine(to: CGPoint(x: notchEndX, y: rect.minY + cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: notchEndX + cornerRadius, y: rect.minY),
                control: CGPoint(x: notchEndX, y: rect.minY)
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()

        case .bottom:
            // Lógica para la muesca en la parte inferior
            let notchX = max(rect.minX + notchLength / 2, min(notchPosition, rect.maxX - notchLength / 2))
            let notchStartX = notchX - notchLength / 2
            let notchEndX = notchX + notchLength / 2

            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: notchStartX - cornerRadius, y: rect.maxY))
            path.addQuadCurve(
                to: CGPoint(x: notchStartX, y: rect.maxY - cornerRadius),
                control: CGPoint(x: notchStartX, y: rect.maxY)
            )
            path.addLine(to: CGPoint(x: notchStartX, y: rect.maxY - notchSize + cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: notchStartX + cornerRadius, y: rect.maxY - notchSize),
                control: CGPoint(x: notchStartX, y: rect.maxY - notchSize)
            )
            path.addLine(to: CGPoint(x: notchEndX - cornerRadius, y: rect.maxY - notchSize))
            path.addQuadCurve(
                to: CGPoint(x: notchEndX, y: rect.maxY - notchSize + cornerRadius),
                control: CGPoint(x: notchEndX, y: rect.maxY - notchSize)
            )
            path.addLine(to: CGPoint(x: notchEndX, y: rect.maxY - cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: notchEndX + cornerRadius, y: rect.maxY),
                control: CGPoint(x: notchEndX, y: rect.maxY)
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.closeSubpath()
        }

        return path
    }
}
