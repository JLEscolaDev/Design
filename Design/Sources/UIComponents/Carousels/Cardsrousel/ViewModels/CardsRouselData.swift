//
//  CardsRouselData.swift
//  Design
//
//  Created by Jose Luis Escolá García on 13/11/24.
//
import SwiftUI

@Observable
class CardsRouselData {
    var cards: [CarrouselCard] = []
    
    init() {
        for i in 0..<10 {
            cards.append(CarrouselCard(intID: i, zIndex: i) {
                AnyView(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green, lineWidth: 6)
                        .background(Color.white)
                        .padding(10)
                        .background(Color.white)
                )
            })
        }
    }
    
    func isTopCard(_ card: CarrouselCard) -> Bool {
        guard let topCard = cards.last else { return false }
        return topCard.id == card.id
    }
    
    func selectCard(_ card: CarrouselCard) {
        for index in cards.indices {
            if cards[index].id == card.id {
                cards[index].isSelected = true
            } else {
                cards[index].isSelected = false
            }
        }
    }
    
    func deselectCard(_ card: CarrouselCard) {
        for index in cards.indices {
            if cards[index].id == card.id {
                cards[index].isSelected = false
            }
        }
    }
    
    func removeTopCard() {
        if !cards.isEmpty {
            cards.removeLast()
        }
    }
}
