//
//  LiquidViewCell.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 7/5/24.
//

import SwiftUI

public struct LiquidViewCell: View {
    public init(enableGlassEffect: Bool = true) {
        self.enableGlassEffect = enableGlassEffect
    }
    
    @State private var animationModel = AnimationModel()
    private static let BUTTON_PADDING:CGFloat = 5
    @State private var rotationAngle: Double = 0
    @State private var bubbleEffect: Bool = false

    private var buttonHeight:CGFloat {
        return (LiquidViewCell.BUTTON_PADDING*2)+17
    }
    
    private var buttonLateralPaddings: CGFloat {
        LiquidViewCell.BUTTON_PADDING*3
    }
    
    private var rotationTime:CGFloat {
        animationModel.frameHeight > animationModel.previousFrameHeight ? 2.35 : 1.75
    }
#if os(iOS)
    @State var coreMotionVM = GlassReflectionEffectMotionViewModel()
#endif
    @State var enableGlassEffect = false
    
    let beerStain: LinearGradient = LinearGradient(gradient: Gradient(colors: [
        .white,
        .white,
        .yellow.opacity(0.15),
        .white,
        .white,
        .white,
        .white
    ]), startPoint: .top, endPoint: .bottom)
    
    var cardTitle: some View {
        Text("Texto de ejemplo")
            .font(.title)
            .fontWeight(.bold)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], 16)
            .padding(.top, 14)
            .foregroundStyle(.black)
    }
    
    var knowMoreButton: some View {
        #if os(macOS)
        knowMoreButtonLabel
            .onTapGesture {
                knowMoreButtonAction()
            }
         // Button position based on his height and his position (if the button new position is out of the card, the offset moves it up)
        .offset(x: -16, y: animationModel.frameHeight - buttonHeight > 0 ? 10 : -buttonHeight)
        // Animate transition to fill and empty (go up and down) with a delay to simulate liquid environment
        .animation(
            .easeInOut(duration: 2).delay(
                animationModel.frameHeight > animationModel.previousFrameHeight ? 0.7 : 0
            ),
            value: animationModel.frameHeight
        )
        
        #else
        Button(action: {
            knowMoreButtonAction()
        }) {
            knowMoreButtonLabel
        }
        // Button position based on his height and his position (if the button new position is out of the card, the offset moves it up)
        .offset(x: -16, y: animationModel.frameHeight - buttonHeight > 0 ? 10 : -buttonHeight)
        // Animate transition to fill and empty (go up and down) with a delay to simulate liquid environment
        .animation(
            .easeInOut(duration: 2).delay(
                animationModel.frameHeight > animationModel.previousFrameHeight ? 0.7 : 0
            ),
            value: animationModel.frameHeight
        )
        #endif
    }
    
    private var knowMoreButtonLabel: some View {
        Text("Saber más")
            .foregroundColor(.black)
            .font(.headline)
            .padding([.top, .bottom], LiquidViewCell.BUTTON_PADDING)
            .padding([.leading, .trailing], buttonLateralPaddings)
            .background(.white)
            .cornerRadius(100)
            .rotationEffect(Angle(degrees: rotationAngle))
    }
    
    private func knowMoreButtonAction() -> Void {
        animationModel.toggleAnimation()
        // Rotate the button to a random angle between -25 and 15 and go back to its init position when it finishes
        withAnimation(.easeInOut(duration: rotationTime/2).delay(animationModel.frameHeight > animationModel.previousFrameHeight ? 0.7 : 0)) {
            rotationAngle = CGFloat.random(in: -25...15)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + rotationTime/2) {
            withAnimation(.easeInOut(duration: rotationTime/2)) {
                rotationAngle = .zero
            }
        }
    }
    
    var liquidContainer: some View {
        ZStack(alignment: .bottomLeading) {
            Text("Esto es un texto de prueba para ver cómo sería la descripción informativa de la celda dentro del líquido.\nTambién para controlar el tema de las transparencias/opacidades y espaciado.")
                .foregroundColor(.black)
                .lineLimit(4)
                .padding(.bottom, 40)
                .padding(.horizontal, 16)
                
            // We use this colors that represents the orange color with 70% opacity and 90% opacity to keep this gradient style but allowing us to hide things behind the liquid
            let orange07 = MultiplatformColor.fromRGB(red: 255/255, green: 172/255, blue: 55/255, alpha: 1).toSwiftUIColor
            let orange09 = MultiplatformColor.fromRGB(red: 255/255, green: 153/255, blue: 12/255, alpha: 1).toSwiftUIColor
            Liquid(speed: animationModel.liquidSpeed, amplitude: animationModel.liquidAmplitude, color: LinearGradient(gradient: Gradient(colors: [orange07,orange09, .orange, .orange,.orange, .orange, orange09]), startPoint: .top, endPoint: .bottom))
                .overlay {
                    // We set the id linked to the frameHeight to ensure we refresh the overlay height when recycling this view.
                    // If we don't use this, the BubbleEffectView is not capable of resicing when the Liquid frameHeight is small, we scroll, and then come back to tap the button (it will keep the small height)
                    BubbleEffectView(turnOnBubbles: $bubbleEffect)
                        .id("BubbleEffectView_\(animationModel.frameHeight)")
                }
                // Moving up and down (filling and emptying the liquid) with a smooth animation
                .animation(.easeInOut(duration: 2.25), value: animationModel.frameHeight)
                .overlay (alignment: .topTrailing) {
                    knowMoreButton
                }
                .blur(radius: 0.5)
                .frame(height: animationModel.frameHeight)
        }
    }
    
    #if os(iOS)
    var gradientColorGlassEfect: some View {
        coreMotionVM.glassEffect
            .animation(
                .easeInOut,
                value: coreMotionVM.roll
            )
    }
    #endif
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            // Round only bottom corners
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 2, bottomLeading: 25, bottomTrailing: 25, topTrailing: 2))
                .fill(beerStain)
                .background {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 2, bottomLeading: 25, bottomTrailing: 25, topTrailing: 2))
                        .fill(Color.white)
                }
                .frame(height: 200)
                .overlay {
                    VStack {
                        cardTitle
                        Spacer()
                        liquidContainer
                    }.clipShape(
                        RoundedRectangle(cornerRadius: 25)
                    )
                }
                .onAppear {
                    DispatchQueue.main.async {
                        animationModel.startAnimation() // Start the initial animation
                        bubbleEffect = true
                        enableGlassEffect = true
                    }
                }.onDisappear() {
                    DispatchQueue.main.async {
                        animationModel.stopAnimation() // Start the initial animation
                        bubbleEffect = false
                        enableGlassEffect = false
                    }
                }
        }
        #if os(iOS)
        .overlay {
            if enableGlassEffect {
                gradientColorGlassEfect
            }
        }
        #endif
        .drawingGroup()
    }
}

// MARK: Preview
struct LiquidViewCellPreview: View {
    var body: some View {
        List(Array(0...10), id: \.self) { id in
            LiquidViewCell()
                .id(id)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 20, leading: 5, bottom: 10, trailing: 5))
        }
    }
}

extension LiquidViewCell {
    public static var preview: some View { LiquidViewCellPreview()
    }
}

#Preview {
    LiquidViewCellPreview()
}
