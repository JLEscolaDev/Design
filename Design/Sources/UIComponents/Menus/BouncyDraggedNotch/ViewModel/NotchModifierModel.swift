//
//  NotchModifierModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 29/11/24.
//

import SwiftUI

@Observable
public class NotchModifierModel {
    public init(
        deformationAmount: CGFloat = 0.0,
        notchLengthMultiplier: CGFloat = 0.3,
        dampingFraction: CGFloat = 0.8,
        notchPosition: CGFloat = 0.0,
        notchSide: NotchPosition = .left,
        allowedSides: NotchSides = .all,
        notchFollowsTouch: Bool = true,
        invertNotchDisplay: Bool = false,
        onNotchEnded: ((NotchPosition, CGFloat) -> Void)? = nil
    ) {
        self.deformationAmount = deformationAmount
        self.notchLengthMultiplier = notchLengthMultiplier
        self.dampingFraction = dampingFraction
        self.notchPosition = notchPosition
        self.notchSide = notchSide
        self.allowedSides = allowedSides
        self.notchFollowsTouch = notchFollowsTouch
        self.invertNotchDisplay = invertNotchDisplay
        self.onNotchEnded = onNotchEnded
    }
    
    var deformationAmount: CGFloat = 0.0
    var notchLengthMultiplier: CGFloat = 0.3
    var dampingFraction: CGFloat = 0.8
    var notchPosition: CGFloat = 0.0
    var notchSide: NotchPosition = .left
    @ObservationIgnored var allowedSides: NotchSides = .all
    @ObservationIgnored var notchFollowsTouch: Bool = true
    @ObservationIgnored var invertNotchDisplay: Bool = false
    @ObservationIgnored var selectedSide: NotchPosition? // Side used for callback
    var onNotchEnded: ((NotchPosition, CGFloat) -> Void)?
    
    let minNotchSize: CGFloat = 20
}

// - MARK: Drag gesture based on tap position
extension NotchModifierModel {
    func processDrag(gesture: DragGesture.Value, geometry: GeometryProxy) {
        dampingFraction = 0.1
        // Determinar el lado según la posición inicial del toque
        let midX = geometry.size.width / 2
        let midY = geometry.size.height / 2
        
        var detectedSide: NotchPosition?
        
        if isDraggingFrom(.top, gesture: gesture, geometry: geometry) {
            let desiredSide: NotchPosition = invertNotchDisplay ? .bottom : .top
            detectedSide = .top
            notchSide = .top
            notchPosition = notchFollowsTouch ? gesture.location.x : geometry.size.width / 2
        } else if isDraggingFrom(.bottom, gesture: gesture, geometry: geometry) {
            let desiredSide: NotchPosition = invertNotchDisplay ? .top : .bottom
            detectedSide = .bottom
            notchSide = .bottom
            notchPosition = notchFollowsTouch ? gesture.location.x : geometry.size.width / 2
        } else if isDraggingFrom(.left, gesture: gesture, geometry: geometry) {
            let desiredSide: NotchPosition = invertNotchDisplay ? .right : .left
            detectedSide = .left
            notchSide = .left
            notchPosition = notchFollowsTouch ? gesture.location.y : geometry.size.height / 2
        } else if isDraggingFrom(.right, gesture: gesture, geometry: geometry) {
            let desiredSide: NotchPosition = invertNotchDisplay ? .left : .right
            detectedSide = .right
            notchSide = .right
            notchPosition = notchFollowsTouch ? gesture.location.y : geometry.size.height / 2
        }
        
        if detectedSide == nil {
            // Si el lado detectado no está permitido, no mostramos la muesca
            deformationAmount = 0
        } else {
            // Calculamos `deformationAmount` en base al arrastre
            let translationBasedOnPosition: CGFloat
            let desiredSide: NotchPosition = invertNotchDisplay ? notchSide.inverted : notchSide
            switch desiredSide {
                case .left:
                    translationBasedOnPosition = gesture.translation.width
                case .right:
                    translationBasedOnPosition = -gesture.translation.width
                case .top:
                    translationBasedOnPosition = gesture.translation.height
                case .bottom:
                    translationBasedOnPosition = -gesture.translation.height
            }
            
            let dragDistance = max(translationBasedOnPosition, minNotchSize)
            let toleranceRange: CGFloat = 10
            selectedSide = dragDistance-toleranceRange > minNotchSize ? notchSide : nil
            deformationAmount = min(dragDistance, 70)
            notchLengthMultiplier = max(min(translationBasedOnPosition/350,0.4), 0.3)
        }
    }
    
    func resetNotch() {
        dampingFraction = 0.8
        deformationAmount = 0 // Volver a la forma original
        // Llamar al callback si existe y si hay un lado detectado
        if let selectedSide {
            onNotchEnded?(selectedSide, notchPosition)
        }
    }
    
    // - MARK: Gesture calculations
    func isDraggingFrom(_ side: NotchSides, gesture: DragGesture.Value, geometry: GeometryProxy) -> Bool {
        let desiredSide: NotchSides = invertNotchDisplay ? side.inverted : side
        return if allowedSides.contains(desiredSide) {
            switch desiredSide {
                case .left:
                    isDraggingFromLeft(gesture: gesture, geometry: geometry)
                case .right:
                    isDraggingFromRight(gesture: gesture, geometry: geometry)
                case .top:
                    isDraggingFromTop(gesture: gesture, geometry: geometry)
                case .bottom:
                    isDraggingFromBottom(gesture: gesture, geometry: geometry)
                default:
                    false
            }
        } else {
            false
        }
    }
    
    func isDraggingFromTop(gesture: DragGesture.Value, geometry: GeometryProxy) -> Bool {
        let midX = geometry.size.width / 2
        let midY = geometry.size.height / 2
        
        return gesture.startLocation.y < midY &&
        gesture.startLocation.x > gesture.startLocation.y &&
        gesture.startLocation.x < geometry.size.width - gesture.startLocation.y
    }
    
    func isDraggingFromBottom(gesture: DragGesture.Value, geometry: GeometryProxy) -> Bool {
        let midX = geometry.size.width / 2
        let midY = geometry.size.height / 2
        
        return gesture.startLocation.y > midY &&
        gesture.startLocation.x > (geometry.size.height - gesture.startLocation.y) &&
        gesture.startLocation.x < geometry.size.width - (geometry.size.height - gesture.startLocation.y)
    }
    
    func isDraggingFromLeft(gesture: DragGesture.Value, geometry: GeometryProxy) -> Bool {
        let midX = geometry.size.width / 2
        let midY = geometry.size.height / 2
        
        return gesture.startLocation.x < midX &&
        gesture.startLocation.y > gesture.startLocation.x &&
        gesture.startLocation.y < geometry.size.height - gesture.startLocation.x
    }
    
    func isDraggingFromRight(gesture: DragGesture.Value, geometry: GeometryProxy) -> Bool {
        let midX = geometry.size.width / 2
        let midY = geometry.size.height / 2
        
        return gesture.startLocation.x > midX &&
        gesture.startLocation.y > (geometry.size.width - gesture.startLocation.x) &&
        gesture.startLocation.y < geometry.size.height - (geometry.size.width - gesture.startLocation.x)
    }
}
