//
//  InformativeCardViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 30/10/24.
//

import SwiftUI

@Observable
class InformativeCardViewModel {
    let text: String
    let type: InformationType
    
    init(text: String, type: InformationType) {
        self.text = text
        self.type = type
    }
    
    var colorBasedOnType: Color {
        switch type {
        case .BASE:
            return Color.white
        case .WARNING:
            return Color.yellow
        case .DANGER:
            return Color.red
        case .SUCCESS:
            return Color.green
        }
    }
    
    var textColorBasedOnType: Color {
        switch type {
        case .BASE, .WARNING:
            return Color.black
        case .DANGER, .SUCCESS:
            return Color.white
        }
    }
    
    var iconBasedOnType: String {
        switch type {
        case .BASE:
            return "info.circle"
        case .WARNING:
            return "exclamationmark.triangle"
        case .DANGER:
            return "xmark.octagon"
        case .SUCCESS:
            return "checkmark.seal"
        }
    }
}
