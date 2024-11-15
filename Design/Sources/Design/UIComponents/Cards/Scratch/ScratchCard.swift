//
//  ScratchCard.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//

import SwiftUI

public struct ScratchCard: View {
    public init(isWinner: Bool, scratchImages: [UIImage] = []) {
        self.isWinner = isWinner
        self.scratchImages = scratchImages.isEmpty ? [UIImage(resource: .scratch), UIImage(resource: .luckyScratch)] : scratchImages
    }
    
    private let scratchImages: [UIImage]
    private let isWinner: Bool
    @State private var onFinish: Bool = false
    
    
    public var body: some View {
        let scratchableImage = scratchImages.randomElement()
        VStack {
            ScratchCardView(cursorSize: 15, onFinish: $onFinish, overlayImage: scratchableImage) {
                VStack {
                    Text("\(isWinner ? "🎊" : "😞")")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    Text("\(isWinner ? "You've Won!" : "You've Lost!")")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    if isWinner {
                        Text("\(isWinner ? "1000€" : "Keep trying")")
                            .font(.title)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .padding(.top, 5)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [Color.white, Color.gray.lighter(by: 0.05)]),
                                center: .center,
                                startRadius: 75,
                                endRadius: 200
                            )
                )
            } overlayView: {
                Image(uiImage: scratchableImage ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(GeometryReader { geometry in
                        Color.clear.preference(key: OverlayImagePreferenceKey.self, value: geometry.frame(in: .local))
                    })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension ScratchCard {
    public static var preview: some View {
        ScratchCard(isWinner: Bool.random())
    }
}

#Preview {
    ScratchCard.preview
}











