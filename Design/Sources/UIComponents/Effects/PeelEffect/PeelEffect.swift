//
//  PeelEffect.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//


import SwiftUI

/// Custom View  Builder
public struct PeelEffect<Content: View>: View {
    var content: Content
    
    /// Delete Callback  for HeadView, When Delete is Clicked
    var onDelete: () -> ()
    
    public init(@ViewBuilder content: @escaping() -> Content, onDelete: @escaping () -> ()) {
        self.content = content()
        self.onDelete = onDelete
    }
    /// View Properties
    /// Progress that represents the X peeling position
    @State private var dragProgress: CGFloat = .zero
    /// Progress that represents the Y peeling position (to allow the user to peel the sticker to the top or bottom)
    @State private var verticalProgress: CGFloat = .zero
    @State private var isExpanded: Bool = false
    @State private var removeSticker: Bool = false
    
    public var body: some View {
        VStack {
            content
                .hidden()
                .overlay {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        let minX = rect.minX
                        
                        /// Replace  it as Background View
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.red.gradient)
                            .overlay(alignment: .trailing) {
                                Button {
                                    /// Removing Card Completely
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        dragProgress = 1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        onDelete()
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                                        .padding(.trailing, 20)
                                        .foregroundStyle(.white)
                                        .contentShape(Rectangle())
                                }
                                .disabled(!isExpanded)
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        removeSticker = false
                                        guard !isExpanded else { return }
                                        /// Use half of the width to follow the exact position of the user finger. If we want to peel all the view, we could use the full width
                                        var translationX = value.translation.width/2
                                        /// Use double of height to follow the finger position. We can use just the height if we want the sticker view to stick to the main view and rotate less.
                                        let translationY = value.translation.height*2
                                        
                                        translationX = max(-translationX, 0)
                                        
                                        let progress = min(1, translationX / rect.width)
                                        let verticalProgress = min(1, abs(translationY) / (rect.height * 2))
                                        
                                        dragProgress = progress
                                        self.verticalProgress = translationY < 0 ? -verticalProgress : verticalProgress
                                    }
                                    .onEnded { value in
                                        guard !isExpanded else { return }
                                            switch dragProgress {
                                                case 0.25...0.35:
                                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.2)) {
                                                        dragProgress = 0.6
                                                        verticalProgress = 0
                                                        isExpanded = true
                                                    }
                                                case 0.35...1:
                                                    withAnimation {
                                                        dragProgress = 1
                                                        verticalProgress = 0.5
                                                        isExpanded = true
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        removeSticker = true
                                                    }
                                                default:
                                                    resetSticker()
                                            }
//                                            if (0.25...0.7).contains(dragProgress) {
//                                                dragProgress = 0.6
//                                                verticalProgress = 0
//                                                isExpanded = true
//                                            } else {
//                                                dragProgress = .zero
//                                                verticalProgress = .zero
//                                                isExpanded = false
//                                            }
//                                        }
                                    }
                            )
                        /// If we Tap Other Than  Delete Button, It will Reset to Initial State
                            .onTapGesture {
                                resetSticker()
                            }
                        
                        /// Shadow
                        Rectangle()
                            .fill(.black)
                            .padding(.vertical, 23)
                            .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
                        
                        /// Moving Alomg Side While Dragging
                            .padding(.trailing, rect.width * dragProgress)
                            .mask(content)
                        
                        /// Disable Interaction
                            .allowsHitTesting(false)
                            .offset(x: dragProgress == 1 ? -minX : 0)
                        
                        content
                            .mask {
                                Rectangle()
                                /// Masking Original Content
                                /// Swipe: Right to Left
                                /// This Masking from Right to Left  (Trailing)
                                    .padding(.trailing, dragProgress * rect.width)
                            }
                        /// Disable Interaction
                            .allowsHitTesting(false)
                            .offset(x: dragProgress == 1 ? -minX : 0)
                    }
                }
                .overlay {
                        GeometryReader {
                            let size = $0.size
                            let minX = $0.frame(in: .global).minX
                            let minOpacity = dragProgress / 0.5
                            let opacity = min(1, minOpacity)
                            
                            content
                            /// Making it Look Like It's Rolling
                                .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 15, y: 0)
                                .overlay {
                                    Rectangle()
                                        .fill(.white.opacity(0.25))
                                        .mask(content)
                                }
                            /// Making is Glow At the Back Side
                                .overlay(alignment: .trailing) {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(colors: [
                                                .clear,
                                                .white,
                                                .clear,
                                                .clear
                                            ], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .frame(width: 60)
                                        .offset(x: 40)
                                        .offset(x: -30 + (30 * opacity))
                                    
                                    /// Moving Alomg Side While Dragging
                                        .offset(x: size.width * -dragProgress)
                                }
                            //                            .scaleEffect(CGSize(width: 1.0, height: 1.0+abs(verticalProgress)), anchor: .trailing)
                            /// Flipping Horizontally for Upside Image
                                .scaleEffect(x: -1)
                            
                            /// Moving Along Side While Dragging
                                .offset(x: size.width - (size.width * dragProgress))
                                .offset(x: size.width * -dragProgress)
                            /// Controls the rotation to animate the peel to the top or bottom anchoring the view instead of rotating the whole view
                                .rotationEffect(.degrees(-verticalProgress*15), anchor: .trailing)
                            /// x progress controls the peel progress, y progress compensates the offset caused by the rotation effect
                                .offset(x: dragProgress == 1 ? -minX : 0,
                                        y: (-verticalProgress*size.height/2) *  dragProgress)
                            //                            .offset(y: size.width * -dragProgress)
                            //                            .rotationEffect(.degrees(-verticalProgress), anchor: .trailing)
                            /// Masking Overlayed Image For Removing Outbound Visibility
                                .mask {
                                    Rectangle()
                                        .offset(x: size.width * -dragProgress)
                                        .frame(height: size.height*2)
                                }
                            
                            
                        }
                        /// Disable Interaction
                        .allowsHitTesting(false)
                        .opacity(removeSticker ? 0 : 1)
                }
        }
    }
    
    private func resetSticker() {
        removeSticker = false
        withAnimation(.spring(response: 0.6, dampingFraction: 0.9, blendDuration: 0.01)) {
            // reset to initial state
            dragProgress = .zero
            verticalProgress = .zero
            isExpanded = false
        }
    }
}


// - MARK: PREVIEW

struct StickerPreview: View {
    @State private var images: [StickerModel] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 50) {
                ForEach(images) { data in
                    PeelEffect {
                        CardView(data.image)
                    } onDelete: {
                        /// Deleting Card
                        if let index = images.firstIndex(where: { cellData in
                            cellData.id == data.id
                        }) {
                            let _ = withAnimation(.easeInOut(duration: 0.35)) {
                                images.remove(at: index)
                            }
                        }
                    }
                }
            }
            .padding(30)
        }
        .onAppear {
            for _ in 1...5 {
                images.append(.init(image: .init(.beerTestScreenshot)))
            }
        }
    }
    
    /// Card View
    @ViewBuilder
    func CardView(_ image: Image) -> some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                Image(.beerTestScreenshot)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                
                Text("💡Hint: Peel me dragging from the right part of the card")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: size.width*0.8)
                    .padding(.top, 70)
            }
        }
        .frame(height: 200)
        .contentShape(Rectangle())
    }
}

extension PeelEffect {
    public static var preview: some View { StickerPreview() }
}

#Preview {
    PeelEffect<AnyView>.preview
}
