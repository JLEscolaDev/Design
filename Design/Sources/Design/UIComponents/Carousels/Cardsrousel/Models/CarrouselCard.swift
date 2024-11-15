//
//  CarrouselCard.swift
//  Design
//
//  Created by Jose Luis Escolá García on 13/11/24.
//
import SwiftUI

struct CarrouselCard: Identifiable, Hashable, Equatable {
    static func == (lhs: CarrouselCard, rhs: CarrouselCard) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    var intID: Int
    var zIndex: Int
    @ViewBuilder var frontView: AnyView
    var isSelected: Bool = false
}

