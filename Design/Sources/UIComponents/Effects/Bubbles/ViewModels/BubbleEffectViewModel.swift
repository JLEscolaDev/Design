//
//  BubbleEffectViewModel.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 7/5/24.
//

import SwiftUI

@Observable
class BubbleEffectViewModel {
    var viewBottom: CGFloat = 0
    var bubbles: [BubbleViewModel] = []
    private var timer: Timer?
    private let maxNumberOfBubbles = 50
    private let secondsToCreateNewBubble = 0.2
    
    func addBubbles(frameSize: CGSize?) {
        timer?.invalidate()
        bubbles.removeAll()
        guard let frameSize else { return }

        timer = Timer.scheduledTimer(withTimeInterval: secondsToCreateNewBubble, repeats: true) { [weak self] _ in
            guard let self = self, self.bubbles.count < self.maxNumberOfBubbles else {
                self?.timer?.invalidate()
                return
            }
            
            // Create a new bubble
            let bubbleColor: Color = .white.opacity(.random(in: 0.2...1)) // Add opacity to create a feeling of depth
            let bubble = BubbleViewModel(
                height: 10,
                width: 10,
                x: CGFloat.random(in: 0...frameSize.width),
                y: self.viewBottom,
                color: bubbleColor,
                lifetime: 0.8
            )
            self.bubbles.append(
                bubble
            )
            
            // Removing the bubble after its lifetime ends
            DispatchQueue.main.asyncAfter(deadline: .now() + bubble.lifetime) {
                self.bubbles.removeAll { $0.id == bubble.id }
            }
        }
    }
}
