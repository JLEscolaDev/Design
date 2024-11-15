
//
//  FrontCardPager.swift
//  masOcio
//
//  Created by Jose Luis Escolá García on 25/7/24.
//  Based on [Simplest Snap Card Carousal In SwiftUI.](https://medium.com/@iamvishal16/simplest-snap-card-carousal-in-swiftui-e6a4395d487b)
//


import SwiftUI

public struct SnapCarouselView: View {
    public init(cards: [InfoCard]) {
        self.cards = cards
    }
    
    @State private var currentIndex: Int = 0
    
    let cards: [InfoCard]
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(cards) { card in
                    CarouselCardView(card: card, currentIndex: $currentIndex, geometry: geometry)
                        .offset(x: CGFloat(card.id - currentIndex) * (geometry.size.width * 0.6))
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let cardWidth = geometry.size.width * 0.3
                        let offset = value.translation.width / cardWidth
                        
                        withAnimation(Animation.spring()) {
                            if value.translation.width < -offset
                            {
                                currentIndex = min(currentIndex + 1, cards.count - 1)
                            } else if value.translation.width > offset {
                                currentIndex = max(currentIndex - 1, 0)
                            }
                        }
                        
                    }
            )
        }
        .padding()
        .padding(.leading, 50)
    }
}

struct Card: Identifiable {
    var id: Int
    var color: Color
}

struct CarouselCardView: View {
    let card: InfoCard
    @Binding var currentIndex: Int
    let geometry: GeometryProxy
    
    var body: some View {
        let cardWidth = geometry.size.width * 0.8
        let cardHeight = cardWidth * 1.5
        let offset = (geometry.size.width - cardWidth) / 2
        
        return VStack {
            card
                .opacity(card.id <= currentIndex + 1 ? 1.0 : 0.0)
                .scaleEffect(card.id == currentIndex ? 1.0 : 0.8)
                .frame(width: cardWidth, height: cardHeight)
                .rotation3DEffect(
                    .degrees(card.id == currentIndex ? 0 : card.id == currentIndex-1 ? -60 : 60),
                    axis: (x: 0.0, y: 1.0, z: 0.0), perspective: 0.3
                )
                .shadow(color: .gray.opacity(0.5), radius: 10, y: 10)
        }
        .frame(width: cardWidth, height: cardHeight)
        .offset(x: CGFloat(card.id - currentIndex) * offset)
    }
}

extension SnapCarouselView {
    public static var preview: some View {
        let cards = [
            InfoCard(vm: .init(id: 0, image: Image(.test), title: "Acampada a las afueras de la ciudad para mirar las estrellas", description: "Escápate con tus amigos y acampa bajo un cielo lleno de estrellas. Enciende una hoguera, comparte historias, y contempla la Vía Láctea lejos de las luces de la ciudad. ¡Una noche mágica que no te puedes perder!", subtitle: "10 planes restantes", style: .default)),
            
            InfoCard(vm: .init(id: 1, image: Image(.test2), title: "Acampada a las afueras de la ciudad para mirar las estrellas", description: "Escápate con tus amigos y acampa bajo un cielo lleno de estrellas. Enciende una hoguera, comparte historias, y contempla la Vía Láctea lejos de las luces de la ciudad. ¡Una noche mágica que no te puedes perder!", subtitle: "10 planes restantes", style: .style2)),
            
            InfoCard(vm: .init(id: 2, image: Image(.test), title: "Acampada a las afueras de la ciudad para mirar las estrellas", subtitle: "10 planes restantes", style: .style3))
        ]
        
        return SnapCarouselView(cards: cards)
    }
}

#Preview {
    SnapCarouselView.preview.padding(.top, 132)
}
