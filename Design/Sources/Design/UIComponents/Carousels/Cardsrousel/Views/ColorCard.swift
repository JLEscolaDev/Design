//
//  ColorCard.swift
//  Design
//
//  Created by Jose Luis Escolá García on 13/11/24.
//

import SwiftUI

struct ColorCard: View {
    @State var data: CardsRouselData
    var card: CarrouselCard
    var reader: GeometryProxy
    
    @State private var offset: CGSize = .zero
    @State private var isDragging = false
    @State private var rotationAngle: Double = 0
    @State private var horizontalCardRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Fondo negro semitransparente cuando la carta está seleccionada
            if isDragging || card.isSelected {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                // Contenido de la carta
                VStack {
                    VStack {
                        // Anverso de la carta
                        VStack {
                            Text("Now you hire me 😎")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .frame(width: 300, height: 400)
                        .background {
                            card.frontView
                        }
                        .cornerRadius(26)
                        .overlay(
                            // Reverso de la carta como overlay
                            Text("FLIP ME!")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .frame(width: 310, height: 400)
                                .background {
                                    Image(.cardBack)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .overlay {
                                            Color.black.opacity(0.3)
                                        }
                                }
                                .cornerRadius(20)
                                .opacity(showingBack ? 1 : 0)
                                .scaleEffect(x: -1) // We mirror the whole view to allow us 3d rotate all the card and seeing the card normally so we need this to rotate the back of the card and set it normal (double negation)
                        )
                    }
                    .shadow(radius: 10)
                    .rotation3DEffect(
                        Angle(degrees: rotationAngle),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .scaleEffect(x: -1)
                    .onTapGesture {
                        if self.isTopCard() {
                            flipCard()
                        }
                    }
                }
//                .rotationEffect(.degrees(rotation))
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Solo la carta superior puede ser arrastrada
                            if data.isTopCard(card) {
                                offset = gesture.translation
                                horizontalCardRotation = Double(offset.width / 20)
//                                rotationAngle = Double(offset.width / 20)
                                isDragging = true
                                data.selectCard(card)
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                if abs(offset.width) > 100 || abs(offset.height) > 100 {
                                    // Puedes definir una acción, como descartar la carta o reiniciarla
                                    data.removeTopCard()
                                } else {
                                    offset = .zero
                                    rotationAngle = 0
                                    isDragging = false
                                    data.deselectCard(card)
                                    
                                }
                                horizontalCardRotation = 0
                            }
                        }
                )
            }
            .zIndex(Double(card.zIndex))
            .position(x: reader.size.width / 2, y: reader.size.height / 2)
            .offset(y: CGFloat(card.zIndex) * 5) // Pequeño desplazamiento para el efecto de pila
            .rotationEffect(cardRotationEffect)
        }
        .onAppear {
            if self.isTopCard() {
                    flipCard()
            }
        }
        .animation(.spring(), value: offset) // Adds a weight/slow down effect to the card while dragging
    }
    
    var cardRotationEffect: Angle {
        if isDragging {
            .degrees(horizontalCardRotation)
        } else {
            // Default card rotation for stack them all
            (card.zIndex % 2 == 0) ?
                .degrees(-0.2 * Double(card.intID % 15 + 1)) :
                .degrees(0.2 * Double(card.intID % 15 + 1))
        }
    }
    
    func flipCard() {
            withAnimation() {
                rotationAngle = rotationAngle == 180 ? 0 :
                 180
            }
        }
    
    var showingBack: Bool {
           rotationAngle == 0
       }
    
    func isTopCard() -> Bool {
        return card.zIndex == self.data.cards.count - 1
    }
}


