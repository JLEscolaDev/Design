import SwiftUI

struct ShadowButtonModifier: ViewModifier {
    var backgroundColor: Color = .black
    var cornerRadius: CGFloat = 25
    var padding: CGFloat = 16
    var shadowColor: Color = .black
    var shadowRadius: CGFloat = 10
    var shadowOpacity: Double = 0.5
    var hoverScale: CGFloat = 1.05
    var hoverDuration: Double = 0.2

    @State private var isHovered: Bool = false

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 5)
            .scaleEffect(isHovered ? hoverScale : 1.0)
            .animation(.easeInOut(duration: hoverDuration), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

extension View {
    func shadowButtonStyle(
        backgroundColor: Color = .black,
        cornerRadius: CGFloat = 25,
        padding: CGFloat = 16,
        shadowColor: Color = .black,
        shadowRadius: CGFloat = 10,
        shadowOpacity: Double = 0.5,
        hoverScale: CGFloat = 1.05,
        hoverDuration: Double = 0.2
    ) -> some View {
        self.modifier(ShadowButtonModifier(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            padding: padding,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowOpacity: shadowOpacity,
            hoverScale: hoverScale,
            hoverDuration: hoverDuration
        ))
    }
}

public struct ShadowButtonPreview: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                print("Button Pressed")
            }) {
                Text("Iniciar Sesión")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadowButtonStyle()
        }
    }
}

// MARK: - Preview
#Preview {
    ShadowButtonPreview()
}
