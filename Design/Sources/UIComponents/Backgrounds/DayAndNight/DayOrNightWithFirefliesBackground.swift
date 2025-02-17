//
//  DayOrNightWithFirefliesBackground.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//

import SwiftUI

public struct DayOrNightWithFirefliesBackground: View {
    public init(isDay: Binding<Bool>) {
        self._isDay = isDay
    }
    
    @State private var fireflies: [Firefly] = []
    @Binding var isDay: Bool
    
    public var body: some View {
        ZStack {
            // Fondo de gradiente de "luz de luna" que creamos previamente
            DayNightToggleBackground(isDay: $isDay)
            
            // Capa de luciérnagas
            
                ForEach(fireflies) { firefly in
                    FireflyView(firefly: firefly)
                }.opacity(isDay ? 0 : 1) // Ocultamos las luciérngas de día usando la animación del toggle
            
            
        }
        .onAppear {
            // Generamos luciérnagas al aparecer la vista
            fireflies = generateFireflies(count: 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
    
    // Genera luciérnagas en posiciones aleatorias con tamaños, opacidades y duración de animación variable
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
