//
//  CarouselView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 4/11/24.
//


import SwiftUI

public struct LeftAlignedCarouselView<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var itemViewBuilder: (Item) -> ItemView

    @State private var currentIndex: Int = 0
    @State private var cardWidth: CGFloat = 0

    public var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 16
            let sidePadding = (geometry.size.width - cardWidth) / 2

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(items.indices, id: \.self) { index in
                        itemViewBuilder(items[index])
                            .frame(width: cardWidth)
                            .scaleEffect(scale(for: index))
                            .opacity(opacity(for: index))
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            .onTapGesture {
                                withAnimation {
                                    currentIndex = index
                                }
                            }
                    }
                }
                .padding(.horizontal, sidePadding)
            }
            .content.offset(x: offset(for: geometry.size.width))
            .frame(width: geometry.size.width, height: 320)
            .padding(.horizontal, 30)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        let translation = value.translation.width

                        if translation < -threshold && currentIndex < items.count - 1 {
                            currentIndex += 1
                        } else if translation > threshold && currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
            )
            .onAppear {
                cardWidth = geometry.size.width * 0.7
            }
        }
    }

    private func scale(for index: Int) -> CGFloat {
        let delta = abs(index - currentIndex)
        return max(0.01, 1 - (CGFloat(delta) * 0.1))
    }

    private func opacity(for index: Int) -> Double {
        let delta = abs(index - currentIndex)
        return Double(max(0.7, 1 - (CGFloat(delta) * 0.3)))
    }

    private func offset(for totalWidth: CGFloat) -> CGFloat {
        let cardSpacing: CGFloat = 16
        let totalCardWidth = cardWidth + cardSpacing
        let xOffset = (CGFloat(currentIndex-1) * totalCardWidth) - (totalWidth - cardWidth) / 2
        return -xOffset
    }
}

// - MARK: PREVIEW

@_spi(Demo) public struct LeftAlignedCarouselPreviewView: View {
    public init() {}
    private struct BasicDataForPreview: Identifiable {
        let id: UUID
        let name: String
        let image: Image?
    }
    private let items = [
        BasicDataForPreview(id: UUID(), name: "Title 1", image: Image(.test)),
        BasicDataForPreview(id: UUID(), name: "Title 2", image: Image(.test)),
        BasicDataForPreview(id: UUID(), name: "Title 3", image: Image(.test)),
        BasicDataForPreview(id: UUID(), name: "Title 4", image: Image(.test))
    ]

    public var body: some View {
        LeftAlignedCarouselView(items: items) { item in
            CarouselItemView(
                image: item.image,
                title: item.name,
                buttonAction1: { print("Joined \(item.name)") },
                buttonAction2: { print("Viewing details of \(item.name)") }
            )
        }.padding(.horizontal, 30)
    }
}

#Preview {
    LeftAlignedCarouselPreviewView()
}
