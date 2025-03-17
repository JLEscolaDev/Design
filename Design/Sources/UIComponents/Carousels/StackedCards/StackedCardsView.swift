//
//  StackedCardsView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 17/3/25.
//


import SwiftUI

public struct StackedCardsView<Content: View>: View where Content: Identifiable & Equatable {
    public init(contentList: [Content]) {
        self.contentList = contentList
    }
    
    @State var contentList: [Content]
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false

    public var body: some View {
        GeometryReader { geometry in
        ZStack {
            ForEach(Array(contentList.enumerated()), id: \.element.id) { index, card in
                card
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(y: index == 0 ? dragOffset.height : CGFloat(index) * geometry.size.height*0.02) // Solo la primera carta se mueve
                    .scaleEffect(1 - (CGFloat(index) * 0.05)) // Profundidad
//                    .opacity(1 - (CGFloat(index) * 0.1)) // Opacidad decreciente
                    .zIndex(Double(contentList.count - index))
                    .gesture(
                        index == 0 ? DragGesture()
                            .onChanged { gesture in
                                dragOffset = gesture.translation
                                isDragging = true
                            }
                            .onEnded { gesture in
                                let dragOffsetSizeForTriggeringAction = geometry.size.height*0.1
                                if gesture.translation.height < -dragOffsetSizeForTriggeringAction { // Swipe Up
                                    moveCardToBack()
                                } else if gesture.translation.height > dragOffsetSizeForTriggeringAction { // Swipe Down
                                    moveCardToFront()
                                }
                                dragOffset = .zero
                                isDragging = false
                            }
                        : nil
                    )
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: contentList)
        }
    }
    
    private func moveCardToBack() {
        withAnimation {
            let movedCard = contentList.removeFirst()
            contentList.append(movedCard)
        }
    }
    
    private func moveCardToFront() {
        withAnimation {
            let movedCard = contentList.removeLast()
            contentList.insert(movedCard, at: 0)
        }
    }
}

extension StackedCardsView {
    public static var preview: some View {
        StackedCardsView<InformativeCard>(contentList: [
            InformativeCard(vm: InformativeCardViewModel(text: "Title", type: .BASE)),
            InformativeCard(vm: InformativeCardViewModel(text: "Text", type: .DANGER)),
            InformativeCard(vm: InformativeCardViewModel(text: "Longer Title", type: .SUCCESS)),
            InformativeCard(vm: InformativeCardViewModel(text: "This is a simple example", type: .WARNING)),
        ]).frame(width: 300)
    }
}

#Preview {
    StackedCardsView<InformativeCard>.preview
}
