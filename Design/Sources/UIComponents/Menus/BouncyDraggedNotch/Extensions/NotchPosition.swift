//
//  NotchPosition.swift
//  Design
//
//  Created by Jose Luis Escolá García on 29/11/24.
//

import SwiftUI

// Enum para definir la posición de la muesca
public enum NotchPosition {
    case left
    case right
    case top
    case bottom
}

extension NotchPosition {
    func toNotchSides() -> NotchSides {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
    
    var inverted: Self {
        switch self {
            case .left:
                return .right
            case .right:
                return .left
            case .top:
                return .bottom
            case .bottom:
                return .top
        }
    }
}
