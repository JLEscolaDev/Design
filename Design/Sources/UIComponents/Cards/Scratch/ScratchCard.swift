//
//  ScratchCard.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//

import SwiftUI

#if os(macOS)
import AppKit
#endif

// MARK: - ScratchCard

#if os(macOS)
public struct ScratchCard: View {
    // Use NSImage on macOS
    public init(isWinner: Bool, scratchImages: [NSImage] = []) {
        self.isWinner = isWinner
        // Default images: Replace with your own NSImage init if needed
        self.scratchImages = scratchImages.isEmpty ? [
            NSImage(named: "scratch") ?? NSImage(),
            NSImage(named: "luckyScratch") ?? NSImage()
        ] : scratchImages
    }
    
    private let scratchImages: [NSImage]
    private let isWinner: Bool
    @State private var onFinish: Bool = false
    
    public var body: some View {
        // Pick a random NSImage
        let scratchableImage = scratchImages.randomElement()
        
        VStack {
            // Use your custom ScratchCardView implementation.
            // NOTE: Make sure your ScratchCardView is also cross-platform
            // (i.e., uses NSImage on macOS).
            ScratchCardView(cursorSize: 15, onFinish: $onFinish, overlayImage: scratchableImage) {
                VStack {
                    Text(isWinner ? "🎊" : "😞")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    Text(isWinner ? "You've Won!" : "You've Lost!")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    if isWinner {
                        Text("1000€")
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
                // Swap to Image(nsImage:) on macOS
                Image(nsImage: scratchableImage ?? NSImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(key: OverlayImagePreferenceKey.self, value: geometry.frame(in: .local))
                        }
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#else
// MARK: - iOS Version
public struct ScratchCard: View {
    // Use UIImage on iOS
    public init(isWinner: Bool, scratchImages: [MultiplatformImage] = []) {
        self.isWinner = isWinner
        // Default images: Replace with your own UIImage init if needed
        self.scratchImages = scratchImages.isEmpty ? [
            MultiplatformImage(resource: .scratch),
            MultiplatformImage(resource: .luckyScratch) ?? UIImage()
        ] : scratchImages
    }
    
    private let scratchImages: [UIImage]
    private let isWinner: Bool
    @State private var onFinish: Bool = false
    
    public var body: some View {
        // Pick a random UIImage
        let scratchableImage = scratchImages.randomElement()
        
        VStack {
            ScratchCardView(cursorSize: 15, onFinish: $onFinish, overlayImage: scratchableImage) {
                VStack {
                    Text(isWinner ? "🎊" : "😞")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    Text(isWinner ? "You've Won!" : "You've Lost!")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    if isWinner {
                        Text("1000€")
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
                // Keep using Image(uiImage:) on iOS
                Image(uiImage: scratchableImage ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(key: OverlayImagePreferenceKey.self, value: geometry.frame(in: .local))
                        }
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
#endif


// MARK: - Preview (Works on both platforms, but the SwiftUI canvas is typically iOS-only in Xcode by default)
extension ScratchCard {
    public static var preview: some View {
        ScratchCard(isWinner: Bool.random())
    }
}

#Preview {
    ScratchCard.preview
}
