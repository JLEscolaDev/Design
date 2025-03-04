//
//  BubbleEffectView.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 7/5/24.
//

import SwiftUI

/// Group of Bubbles 
public struct BubbleEffectView: View {
    public init(turnOnBubbles: Binding<Bool>) {
        self._turnOnBubbles = turnOnBubbles
    }
    
    @State private var viewModel = BubbleEffectViewModel()
    @Binding var turnOnBubbles: Bool

    public var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                ForEach(viewModel.bubbles) { bubble in
                    BubbleView(bubble: bubble)
                }
            }
            .onChange(of: turnOnBubbles) {
                addBubbles(geometrySize: size)
            }
            .onChange(of: size) { oldSize, newSize in
                viewModel.viewBottom = newSize.height
                addBubbles(geometrySize: newSize)
            }
            .onAppear {
                viewModel.viewBottom = size.height
                addBubbles(geometrySize: size)
            }
        }
    }
    
    private func addBubbles(geometrySize: CGSize) {
        viewModel.addBubbles(frameSize: turnOnBubbles ? geometrySize : nil)
    }
}

// MARK: Preview
struct BubblesEffectTestingView: View {
    @State var toggleBubbles: Bool = false

    var body: some View {
        ZStack {
            backgroundColor
            BubbleEffectView(turnOnBubbles: $toggleBubbles)
            toggleBubblesButton
        }
    }
    
    private var backgroundColor: Color {
        Color.blue
    }
    
    private var toggleBubblesButton: some View {
        Button("Turn \(toggleBubbles ? "off" : "on") bubbles") {
            toggleBubbles.toggle()
        }
        .foregroundColor(.white)
        .fontWeight(.black)
        .padding()
    }
}

extension BubbleEffectView {
    public static var preview: some View { BubblesEffectTestingView()
    }
}

#Preview {
    BubblesEffectTestingView()
}
