////
////  MasOcioRadioImageSizeSelector.swift
////  Design
////
////  Created by Jose Luis Escolá García on 4/11/24.
////
//
//
//import Design
//import SwiftUI
//
//struct MasOcioRadioImageSizeSelector: View {
//    init(icon: Image?, iconSize: CGSize, selectionCircleSize: CGSize = CGSize(width: 80, height: 80), selectWhenSizeIs: Size, currentSize: Size, yOffset: CGFloat = 0) {
//        self.icon = icon
//        self.iconSize = iconSize
//        self.selectionCircleSize = selectionCircleSize
//        self.selectedSize = selectWhenSizeIs
//        self.currentSize = currentSize
//        self.yOffset = yOffset
//    }
//    
//    let icon: Image?
//    let iconSize: CGSize
//    var selectionCircleSize: CGSize = CGSize(width: 80, height: 80)
//    let selectedSize: Size
//    let yOffset: CGFloat
//    @State var currentSize: Size
//    
//    var body: some View {
//        RadioImageSizeSelector(icon: icon,
//                               iconSize: iconSize,
//                               iconSelectionColor: Color(.coffeText),
//                               iconDefaultColor: .gray,
//                               selectionCircleSize: selectionCircleSize,
//                               circleSelectionColor: Color(.lightCoffee),
//                               circleDefaultColor: .clear,
//                               selectWhenSizeIs: selectedSize,
//                               currentSize: currentSize,
//                               yOffset: yOffset)
//    }
//}
//
//#Preview {
//    MasOcioRadioImageSizeSelector(icon: Image(systemName: "person.crop.circle"), iconSize: CGSize(width: 100, height: 100), selectionCircleSize: CGSize(width: 100, height: 100), selectWhenSizeIs: .large, currentSize: .large)
//}
//
//
////class AnimationModel: ObservableObject {
////    @Published var animationState: AnimationState = .FULL
////    @Published var liquidSpeed: Double = 0
////    @Published var liquidAmplitude: Double = 0
////    @Published var animationProgress: Double = 0.0
////
////    private let duration: TimeInterval = 1.25
////    private let animationFrames: Int = 60
////    private var currentFrame: Int = 0
////    private var timer: Timer?
////    private var isFilling = true
////
////    private var previousAnimationState: AnimationState = .FULL
////
////    private var frameDuration: TimeInterval {
////        duration / Double(animationFrames)
////    }
////
////    init() {
////        let numberOFAnimationstates = AnimationState.allCases.count
////        let currentAnimationStateIndex = AnimationState.allCases.firstIndex(of: animationState) ?? 0
////       isFilling = currentAnimationStateIndex < numberOFAnimationstates-1
////    }
////
////    func toggleAnimation() {
////        stopAnimation()
////        DispatchQueue.main.asyncAfter(deadline: .now() + frameDuration) { [self] in
////            let numberOFAnimationstates = AnimationState.allCases.count
////            let currentAnimationStateIndex = AnimationState.allCases.firstIndex(of: animationState) ?? 0
////
////            if currentAnimationStateIndex < numberOFAnimationstates-1 && isFilling {
////                animationState = AnimationState.allCases[currentAnimationStateIndex+1]
////                isFilling = (currentAnimationStateIndex+2 <= numberOFAnimationstates-1)
////            }else {
////                animationState = AnimationState.allCases[currentAnimationStateIndex-1]
////                isFilling = !(currentAnimationStateIndex-2 >= 0)
////            }
////
//////            self.isFull.toggle()
////            self.startAnimation()
////        }
////    }
////
////
////    private func startAnimation() {
////        currentFrame = 0
////        switch animationState {
////        case .FULL:
////            liquidSpeed = 0
////        case .MID_FULL:
////            liquidSpeed = 2.0
////        case .EMPTY:
////            liquidSpeed = 0.5
////        }
//////        liquidSpeed = isFull ? 0.0 : 2.0
////
////        timer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { [weak self] timer in
////            guard let self = self else { return }
////            self.updateAnimation()
////        }
////    }
////
////    private func stopAnimation() {
////        timer?.invalidate()
////        timer = nil
////    }
////
//////    private func updateAnimation() {
//////        let progress = Double(currentFrame) / Double(animationFrames)
//////        let speed = isFull ? progress * 2.0 : (1.0 - progress) * 2.0
//////
//////        liquidAmplitude = isFull ? progress * 10.0 : (1.0 - progress) * 10.0
//////        liquidSpeed = speed
//////
//////        currentFrame += 1
//////        if currentFrame > animationFrames {
//////            stopAnimation()
//////        }
//////    }
////    private func updateAnimation() {
////        let progress = Double(currentFrame) / Double(animationFrames)
//////                animationProgress = isFull ? progress : 1.0 - progress
////        switch animationState {
////        case .FULL:
////            animationProgress = 1
////            liquidAmplitude = sin(progress * .pi / 2.0) * 10.0
////            liquidSpeed = 2.0
////        case .MID_FULL:
////            animationProgress = progress
////            liquidAmplitude = sin((1.0 - progress) * .pi / 2.0) * 10.0
////            liquidSpeed = 0.0
////        case .EMPTY:
////            animationProgress = 1
////            liquidAmplitude = sin(progress * .pi / 2.0) * 10.0
////            liquidSpeed = 2.0
////        }
////
//////        if isFull {
//////            liquidAmplitude = sin(progress * .pi / 2.0) * 10.0
//////            liquidSpeed = 2.0
//////        } else {
//////            liquidAmplitude = sin((1.0 - progress) * .pi / 2.0) * 10.0
//////            liquidSpeed = 0.0
//////        }
//////
////        currentFrame += 1
////
////        if currentFrame > animationFrames {
////            stopAnimation()
////        }
////    }
////
////    enum AnimationState: CaseIterable {
////        case FULL, MID_FULL, EMPTY
////    }
////
////}
//
//
//import SwiftUI
//import Combine
//
//struct LiquidViewCell: View {
//    @StateObject private var animationModel = AnimationModel()
//    private static let BUTTON_PADDING:CGFloat = 5
//    @State private var rotationAngle: Double = 0
//
//    private var buttonHeight:CGFloat {
//        return (LiquidViewCell.BUTTON_PADDING*2)+17
//    }
//    
//    private var buttonLateralPaddings: CGFloat {
//        LiquidViewCell.BUTTON_PADDING*3
//    }
//    
//    private var rotationTime:CGFloat {
//        animationModel.frameHeight > animationModel.previousFrameHeight ? 2.35 : 1.75
//    }
//    
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            RoundedRectangle(cornerRadius: 25)
//                .foregroundColor(.white)
//                .frame(width: 350, height: 200)
//                .overlay(
//                    VStack {
//                        Text("Texto de ejemplo")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .lineLimit(1)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding([.leading, .trailing], 16)
//                            .padding(.top, 10)
//                        Spacer()
//                        ZStack(alignment: .topTrailing) {
//                            Liquid(speed: animationModel.liquidSpeed, amplitude: animationModel.liquidAmplitude)
//                                .foregroundColor(.orange)
//                            // Moving up and down (filling and emptying the liquid) with a smooth animation
//                                .animation(.easeInOut(duration: 2.25), value: animationModel.frameHeight)
//                                .overlay (alignment: .topTrailing) {
//                                    Button(action: {
//                                        animationModel.toggleAnimation()
//                                        // Rotate the button to a random angle between -25 and 15 and go back to its init position when it finishes
//                                        withAnimation(.easeInOut(duration: rotationTime/2).delay(animationModel.frameHeight > animationModel.previousFrameHeight ? 0.7 : 0)) {
//                                                        rotationAngle = CGFloat.random(in: -25...15)
//                                                    }
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + rotationTime/2) {
//                                                withAnimation(.easeInOut(duration: rotationTime/2)) {
//                                                    rotationAngle = .zero
//                                                }
//                                            }
//                                    }) {
//                                        Text("Saber más")
//                                            .foregroundColor(.black)
//                                            .font(.headline)
//                                            .padding([.top, .bottom], LiquidViewCell.BUTTON_PADDING)
//                                            .padding([.leading, .trailing], buttonLateralPaddings)
//                                            .background(.white)
//                                            .cornerRadius(100)
//                                            .rotationEffect(Angle(degrees: rotationAngle))
//                                    }
//                                    // Button position based on his height and his position (if the button new position is out of the card, the offset moves it up)
//                                    .offset(x: -16, y: animationModel.frameHeight - buttonHeight > 0 ? 10 : -buttonHeight)
//                                    // Animate transition to fill and empty (go up and down) with a delay to simulate liquid environment
//                                        .animation(.easeInOut(duration: 2).delay(animationModel.frameHeight > animationModel.previousFrameHeight ? 0.7 : 0), value: animationModel.frameHeight)
//                                    // Spring animation to improve the liquid environment feeling
//                                        .animation(.spring(response: 1, dampingFraction: 0.5, blendDuration: 0))
//                                }.frame(height: animationModel.frameHeight)
//
//                            
//                        }
//                    }
//                    .clipShape(
//                        RoundedRectangle(cornerRadius: 25)
//                    )
//                )
//                .onAppear {
//                    DispatchQueue.main.async {
//                        animationModel.startAnimation() // Start the initial animation
//                    }
//                }.onAppear {
//                    DispatchQueue.main.async {
//                        animationModel.stopAnimation() // Start the initial animation
//                    }
//                }
//        }
//        .padding()
//        .background(.gray)
//    }
//}
//
//
//
//import SwiftUI
//
//class AnimationModel: ObservableObject {
//    @Published var animationState: AnimationState = .FULL
//    @Published var liquidSpeed: Double = 0
//    @Published var liquidAmplitude: Double = 0
//    @Published var animationProgress: Double = 0.0
//    @Published var frameHeight: CGFloat = 150
//    var previousFrameHeight: CGFloat = 150
//
//    private let duration: TimeInterval = 1.75
//    private let animationFrames: Int = 60
//    private var currentFrame: Int = 0
//    private var timer: Timer?
//    private var previousAnimationState: AnimationState = .EMPTY
//
//    private var frameDuration: TimeInterval {
//        duration / Double(animationFrames)
//    }
//
//    init() {
//        previousAnimationState = animationState
//    }
//    
//    deinit {
//        stopAnimation()
//    }
//
//    func toggleAnimation() {
//        stopAnimation()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + frameDuration) {
//            self.animationState = self.getNextAnimationState()
//            self.startAnimation()
//            self.stopAnimation()
//            DispatchQueue.main.asyncAfter(deadline: .now() + self.frameDuration) {
//                self.animationState = self.getNextAnimationState()
//                self.startAnimation()
//            }
//        }
//        
//        
//    }
//
//    private func getNextAnimationState() -> AnimationState {
//        var newAnimationState = AnimationState.FULL
//        let newPreviousAnimationState = animationState
//        switch animationState {
//        case .FULL:
//            newAnimationState = .MID_FULL
//        case .MID_FULL:
//            if previousAnimationState == .EMPTY {
//                newAnimationState = .FULL
//            } else {
//                newAnimationState = .EMPTY
//            }
//        case .EMPTY:
//            newAnimationState = .MID_FULL
//        }
//        previousAnimationState = newPreviousAnimationState
//        return newAnimationState
//    }
//
//    func startAnimation() {
//        currentFrame = 0
//        previousFrameHeight = frameHeight
//        switch animationState {
//        case .FULL:
//            liquidSpeed = 6.0
//            liquidAmplitude = 0.0
//            frameHeight = 150
//        case .MID_FULL:
//            liquidSpeed = 6.0
//            liquidAmplitude = 5.0
//            frameHeight = 75
//        case .EMPTY:
//            liquidSpeed = 6.0
//            liquidAmplitude = 0.0
//            frameHeight = 15
//        }
//
//        timer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { [weak self] timer in
//            guard let self = self else { return }
//            // Animate transition if it is not first time the view appears
//            if !(self.animationState == .FULL && self.previousAnimationState == .FULL) {
//                self.updateAnimation()
//            }
//        }
//    }
//
//    func stopAnimation() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//    private func updateAnimation() {
//        let progress = Double(currentFrame) / Double(animationFrames)
//        
//        switch animationState {
//        case .FULL:
//            animationProgress = 1.0 - progress
//        case .MID_FULL:
//            animationProgress = progress
//        case .EMPTY:
//            animationProgress = 1.0 - progress
//        }
//        
//        liquidAmplitude = sin(animationProgress * .pi / 2.0) * 10.0
//        
//        currentFrame += 1
//        
//        if currentFrame > animationFrames {
//            stopAnimation()
//        }
//    }
//
//    enum AnimationState {
//        case FULL, MID_FULL, EMPTY
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//public struct Liquid: View {
//    public let speed: Double
//    public let amplitude: Double
//    
//    public init(speed: Double = 1, amplitude: Double? = nil) {
//        self.speed = speed
//        self.amplitude = amplitude ?? 10
//    }
//    
//    public var body: some View {
//        TimelineView(.animation) { ctx in
//            Shape(time: speed * ctx.date.timeIntervalSince1970, amplitude: amplitude)
//        }
//    }
//    
//    public static func debug() -> some View {
//        InteractivePreview()
//    }
//    
//    public struct Shape: SwiftUI.Shape, Animatable {
//        public var time: Double
//        public var scale: Double
//        public var amplitude: Double
//        public let contentMode: ContentMode
//        public let resolution: Double
//        public var animationProgress: Double
//        
//        public enum ContentMode: String, CaseIterable, Identifiable {
//            case contain
//            case overlap
//            case fill
//            
//            public var id: String { rawValue }
//        }
//        
//        public var animatableData: AnimatablePair<Double, AnimatablePair<Double, AnimatablePair<Double, Double>>> {
//            get {
//                AnimatablePair(time, AnimatablePair(scale, AnimatablePair(amplitude, animationProgress)))
//            }
//            set {
//                time = newValue.first
//                scale = newValue.second.first
//                amplitude = newValue.second.second.first
//                animationProgress = newValue.second.second.second
//            }
//        }
//
//        
//        public init(
//                time: Double,
//                scale: Double = 2 * .pi,
//                amplitude: Double = 10,
//                animationProgress: Double = 0.0,
//                contentMode: ContentMode = .contain,
//                resolution: Double = .pi / 12
//            ) {
//                self.time = time
//                self.scale = scale
//                self.amplitude = amplitude
//                self.animationProgress = animationProgress
//                self.contentMode = contentMode
//                self.resolution = resolution
//            }
//        
//        var yOffset: Double {
//            switch contentMode {
//            case .contain:
//                return 2
//            case .overlap:
//                return 0
//            case .fill:
//                return -2
//            }
//        }
//        
////        public func path(in rect: CGRect) -> Path {
////            Path { path in
////                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
////
////                for step in stride(from: 0, to: scale, by: resolution) {
////                    let x = rect.maxX * (step / (scale - resolution))
////                    let y = amplitude * (sin(step + time)
////                                         + sin(0.5 * step - 0.5 * time)
////                                         + yOffset)
////
////                    path.addLine(to: CGPoint(x: x, y: y))
////                }
////
////                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
////                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
////                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
////            }
////        }
//        
//        public func path(in rect: CGRect) -> Path {
//            var path = Path()
//            
//            let stepSize = CGFloat(resolution)
//            let xScale = rect.width / CGFloat(scale - resolution)
//            let yOffset = CGFloat(self.yOffset)
//            
//            let startPoint = CGPoint(x: rect.minX, y: rect.minY)
//            path.move(to: startPoint)
//            
//            var previousPoint = startPoint
//            let adjustedTime = time + animationProgress
//            
//            for x in stride(from: rect.minX, through: rect.maxX, by: stepSize) {
//                let normalizedX = (x - rect.minX) / rect.width
//                let step = scale * Double(normalizedX)
//                
//                let y = amplitude * (sin(step + adjustedTime) + sin(0.5 * step - 0.5 * adjustedTime) + yOffset)
//                let point = CGPoint(x: x, y: y)
//                
//                // Add a curve segment instead of a straight line
//                path.addQuadCurve(to: point, control: CGPoint(x: (previousPoint.x + point.x) / 2, y: (previousPoint.y + point.y) / 2))
//                
//                previousPoint = point
//            }
//            
//            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//            path.addLine(to: startPoint)
//            
//            return path
//        }
//
//    }
//    
//    private struct InteractivePreview: View {
//        @State var speed = 1.0
//        @State var scale = 2.0 * .pi
//        @State var amplitude = 10.0
//        @State var contentMode: Liquid.Shape.ContentMode = .contain
//        @State var resolution = .pi / 12.0
//        
//        var body: some View {
//            TimelineView(.animation) { ctx in
//                Liquid.Shape(
//                    time: speed * ctx.date.timeIntervalSince1970,
//                    scale: scale,
//                    amplitude: amplitude,
//                    contentMode: contentMode,
//                    resolution: resolution
//                )
//                .border(.green)
//            }
//            .overlay(alignment: .bottom) {
//                VStack {
//                    let format = FloatingPointFormatStyle<Double>
//                        .number.precision(.fractionLength(2))
//                    
//                    HStack {
//                        Text("Speed").padding(.trailing)
//                        Slider(value: $speed, in: 0.1...10)
//                        Text("\(speed, format: format)")
//                    }
//                    HStack {
//                        Text("Scale").padding(.trailing)
//                        Slider(value: $scale, in: 1...(100 * .pi))
//                        Text("\(scale, format: format)")
//                    }
//                    HStack {
//                        Text("Amplitude").padding(.trailing)
//                        Slider(value: $amplitude, in: 1...100)
//                        Text("\(amplitude, format: format)")
//                    }
//                    HStack {
//                        Text("Resolution").padding(.trailing)
//                        Slider(value: $resolution, in: 0.01...(10 * .pi / 12.0))
//                        Text("\(resolution, format: format)")
//                    }
//                    HStack {
//                        Text("Content Mode").padding(.trailing)
//                        Picker("Content Mode", selection: $contentMode) {
//                            ForEach(Liquid.Shape.ContentMode.allCases) { mode in
//                                Text(mode.rawValue.capitalized).tag(mode)
//                            }
//                        }
//                        .pickerStyle(.segmented)
//                    }
//                }
//                .tint(.white)
//                .foregroundColor(.white)
//                .padding(.bottom, 40)
//                .scenePadding()
//            }
//        }
//    }
//}
//
//
//
//
//
//
//struct Liquid_Previews: PreviewProvider {
//    static var previews: some View {
//        Liquid(speed: 2)
//            .previewLayout(.sizeThatFits)
//            .foregroundColor(.blue)
//            .padding(.top, 200)
//
//        Liquid.debug()
//            .previewLayout(.sizeThatFits)
//            .foregroundColor(.blue)
//            .padding(.top, 200)
//    }
//}
