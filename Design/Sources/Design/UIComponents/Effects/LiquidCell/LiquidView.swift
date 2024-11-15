//
//  LiquidView.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 7/5/24.
//

import SwiftUI

public struct Liquid: View {
    public let speed: Double
    public let amplitude: Double
    private let color: LinearGradient
    
    public init(speed: Double = 1, amplitude: Double? = nil, color: LinearGradient) {
        self.speed = speed
        self.amplitude = amplitude ?? 10
        self.color = color
    }
    
    public var body: some View {
        TimelineView(.animation) { ctx in
            Shape(time: speed * ctx.date.timeIntervalSince1970, amplitude: amplitude)
                .fill(color)
        }
    }
    
    public struct Shape: SwiftUI.Shape, Animatable {
        public var time: Double
        public var scale: Double
        public var amplitude: Double
        public let contentMode: ContentMode
        public let resolution: Double
        public var animationProgress: Double
        
        public enum ContentMode: String, CaseIterable, Identifiable, Sendable {
            case contain
            case overlap
            case fill
            
            public var id: String { rawValue }
        }
        
        public var animatableData: AnimatablePair<Double, AnimatablePair<Double, AnimatablePair<Double, Double>>> {
            get {
                AnimatablePair(time, AnimatablePair(scale, AnimatablePair(amplitude, animationProgress)))
            }
            set {
                time = newValue.first
                scale = newValue.second.first
                amplitude = newValue.second.second.first
                animationProgress = newValue.second.second.second
            }
        }

        
        public init(
                time: Double,
                scale: Double = 2 * .pi,
                amplitude: Double = 10,
                animationProgress: Double = 0.0,
                contentMode: ContentMode = .contain,
                resolution: Double = .pi / 12
            ) {
                self.time = time
                self.scale = scale
                self.amplitude = amplitude
                self.animationProgress = animationProgress
                self.contentMode = contentMode
                self.resolution = resolution
            }
        
        var yOffset: Double {
            switch contentMode {
            case .contain:
                return 2
            case .overlap:
                return 0
            case .fill:
                return -2
            }
        }
        
        public func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let stepSize = CGFloat(resolution)
            let xScale = rect.width / CGFloat(scale - resolution)
            let yOffset = CGFloat(self.yOffset)
            
            let startPoint = CGPoint(x: rect.minX, y: rect.minY)
            path.move(to: startPoint)
            
            var previousPoint = startPoint
            let adjustedTime = time + animationProgress
            
            for x in stride(from: rect.minX, through: rect.maxX, by: stepSize) {
                let normalizedX = (x - rect.minX) / rect.width
                let step = scale * Double(normalizedX)
                
                let y = amplitude * (sin(step + adjustedTime) + sin(0.5 * step - 0.5 * adjustedTime) + yOffset)
                let point = CGPoint(x: x, y: y)
                
                // Add a curve segment instead of a straight line
                path.addQuadCurve(to: point, control: CGPoint(x: (previousPoint.x + point.x) / 2, y: (previousPoint.y + point.y) / 2))
                
                previousPoint = point
            }
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: startPoint)
            
            return path
        }
    }
}

// MARK: Preview
private struct LiquidInteractivePreview: View {
    @State var speed = 1.0
    @State var scale = 2.0 * .pi
    @State var amplitude = 10.0
    @State var contentMode: Liquid.Shape.ContentMode = .contain
    @State var resolution = .pi / 12.0
    
    var body: some View {
        TimelineView(.animation) { ctx in
            Liquid.Shape(
                time: speed * ctx.date.timeIntervalSince1970,
                scale: scale,
                amplitude: amplitude,
                contentMode: contentMode,
                resolution: resolution
            )
            .border(.green)
        }
        .overlay(alignment: .bottom) {
            VStack {
                let format = FloatingPointFormatStyle<Double>
                    .number.precision(.fractionLength(2))
                
                HStack {
                    Text("Speed").padding(.trailing)
                    Slider(value: $speed, in: 0.1...10)
                    Text("\(speed, format: format)")
                }
                HStack {
                    Text("Scale").padding(.trailing)
                    Slider(value: $scale, in: 1...(100 * .pi))
                    Text("\(scale, format: format)")
                }
                HStack {
                    Text("Amplitude").padding(.trailing)
                    Slider(value: $amplitude, in: 1...100)
                    Text("\(amplitude, format: format)")
                }
                HStack {
                    Text("Resolution").padding(.trailing)
                    Slider(value: $resolution, in: 0.01...(10 * .pi / 12.0))
                    Text("\(resolution, format: format)")
                }
                HStack {
                    Text("Content Mode").padding(.trailing)
                    Picker("Content Mode", selection: $contentMode) {
                        ForEach(Liquid.Shape.ContentMode.allCases) { mode in
                            Text(mode.rawValue.capitalized).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .tint(.white)
            .foregroundColor(.white)
            .padding(.bottom, 40)
            .scenePadding()
        }
    }
}

struct Liquid_Previews: PreviewProvider {
    static var previews: some View {
        // We use this colors that represents the orange color with 70% opacity and 90% opacity to keep this gradient style but allowing us to hide things behind the liquid
        let orange07 = Color(uiColor: UIColor(red: 255/255, green: 172/255, blue: 55/255, alpha: 1))
        let orange09 = Color(uiColor: UIColor(red: 255/255, green: 153/255, blue: 12/255, alpha: 1))
        
        Liquid(speed: 2,
               color: LinearGradient(gradient: Gradient(colors: [orange07,orange09, .orange, .orange,.orange, .orange, orange09]), startPoint: .top, endPoint: .bottom))
            .previewLayout(.sizeThatFits)
            .foregroundColor(.blue)
            .padding(.top, 200)
            .ignoresSafeArea()

        LiquidInteractivePreview()
            .previewLayout(.sizeThatFits)
            .foregroundColor(.blue)
            .padding(.top, 200)
    }
}
