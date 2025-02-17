import SwiftUI

public struct ElementLoadingPlaceholderView: View {
    @State private var isAnimating: Bool = false
    private let rotationAngle: Angle
    private let linearGradient: LinearGradient
    private let animation: Animation
    private let primaryColor: Color
    private let shimmerColor: Color
    private let cornerRadius: CGFloat
    
    public init(rotationAngle: Angle = Angle(degrees: 70),
                animationSpeed: CGFloat = 1.3,
                primaryColor: Color = .black.opacity(0.2),
                shimmerColor: Color = .white.opacity(0.6),
                cornerRadius: CGFloat = 10) {
        self.rotationAngle = rotationAngle
        self.linearGradient = LinearGradient(colors: [shimmerColor.opacity(0.1),
                                                      shimmerColor,
                                                      shimmerColor.opacity(0.1)],
                                             startPoint: .top,
                                             endPoint: .bottom)
        self.animation = Animation.linear(duration: Double(animationSpeed))
            .repeatForever(autoreverses: false)
        self.primaryColor = primaryColor
        self.shimmerColor = shimmerColor
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        primaryColor
            .overlay(shimmerLayer())
            .cornerRadius(cornerRadius)
            .onAppear { isAnimating = true }
            .onDisappear { isAnimating = false }
    }
    
    private func shimmerLayer() -> some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(linearGradient)
                .frame(width: geometry.size.width * 1.5, height: geometry.size.height)
                .rotationEffect(rotationAngle)
                .offset(x: isAnimating ? geometry.size.width * 1.5 : -geometry.size.width * 1.5)
                .animation(animation, value: isAnimating)
        }
    }
}

// MARK: - Preview

public extension ElementLoadingPlaceholderView {
    static var preview: some View {
        VStack(spacing: 10) {
            HStack {
                ElementLoadingPlaceholderView()
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    ElementLoadingPlaceholderView()
                        .frame(width: 180, height: 13)
                    ElementLoadingPlaceholderView()
                        .frame(width: 120, height: 13)
                    ElementLoadingPlaceholderView()
                        .frame(width: 60, height: 13)
                }
            }
            
            ElementLoadingPlaceholderView()
                .frame(width: 350, height: 200)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    ElementLoadingPlaceholderView.preview
}
