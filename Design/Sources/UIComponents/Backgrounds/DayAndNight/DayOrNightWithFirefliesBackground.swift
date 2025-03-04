import SwiftUI

#if os(macOS)
import AppKit
#endif

public struct DayOrNightWithFirefliesBackground: View {
    public init(isDay: Binding<Bool>) {
        self._isDay = isDay
    }
    
    @State private var fireflies: [Firefly] = []
    @Binding var isDay: Bool
    
    public var body: some View {
        ZStack {
            // Background
            DayNightToggleBackground(isDay: $isDay)
            
            // Fireflies
            ForEach(fireflies) { firefly in
                FireflyView(firefly: firefly)
            }
            .opacity(isDay ? 0 : 1) // Hide fireflies by day
        }
        .onAppear {
            // Get screen dimensions differently for macOS vs iOS
            let screenWidth  = MultiplatformScreen.bounds.width
            let screenHeight = MultiplatformScreen.bounds.height
            
            fireflies = generateFireflies(
                count: 10,
                width: screenWidth,
                height: screenHeight
            )
        }
    }
    
    // Generate random-position fireflies
    func generateFireflies(count: Int, width: CGFloat, height: CGFloat) -> [Firefly] {
        return (0..<count).map { _ in
            Firefly(
                xPosition: CGFloat.random(in: 0...width),
                yPosition: CGFloat.random(in: 0...height),
                size: CGFloat.random(in: 10...20),
                opacity: Double.random(in: 0.1...1.0),
                animationDuration: Double.random(in: 1...4)
            )
        }
    }
}

// - MARK: PREVIEW

struct DayOrNightWithFirefliesBackgroundPreview: View {
    @State var isDay: Bool = false
    
    var body: some View {
        ZStack {
            DayOrNightWithFirefliesBackground(isDay: $isDay)
            
            // Toggle Button
            dayNightToggleButton
        }
    }
    
    private var dayNightToggleButton: some View {
        VStack {
            Spacer()
            Button(action: {
                withAnimation(.easeInOut(duration: 2)) {
                    isDay.toggle()
                }
            }) {
                Text("Toggle Day/Night")
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
            }
            .multiplatformButton()
            .padding(.bottom, 50)
        }
    }
}

extension DayOrNightWithFirefliesBackground {
    public static var preview: some View {
        DayOrNightWithFirefliesBackgroundPreview()
    }
}

#Preview {
    DayOrNightWithFirefliesBackground.preview
}
