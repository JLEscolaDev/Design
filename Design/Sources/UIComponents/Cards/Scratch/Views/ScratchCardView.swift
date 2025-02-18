//
//  ScratchCardView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//
import SwiftUI

struct ScratchCardView<Content: View, OverlayView: View>: View {
    var content: Content
    var overlayView: OverlayView
    
    /// - Parameters:
    ///   - cursorSize: Cursor size
    ///   - onFinish: boolean that controls onFinish action
    ///   - overlayImage: Image used to build the overlayView. This image will be used to extract the pixel color when scratching to generate the static dirt particles tinted with the image color to improve realism
    ///   - content: Hidden view to display when scratched
    ///   - overlayView: Scratchable view
    init(
        cursorSize: CGFloat,
        onFinish: Binding<Bool>,
        overlayImage: MultiplatformImage?,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) {
        self.content = content()
        self.overlayView = overlayView()
        self.cursorSize = cursorSize
        self._onFinish = onFinish
        self._overlayImage = .init(initialValue: overlayImage)
    }
    
    @State private var strokes: [[CGPoint]] = [[]]
    @State private var dirtParticles: [DirtParticle] = []
    @GestureState private var gestureLocation: CGPoint = .zero
    
    private var cursorSize: CGFloat
    @Binding private var onFinish: Bool
    
    @State private var overlayImageFrame: CGRect = .zero
    @State private var overlayImage: MultiplatformImage?
    @State private var allowGeneratingMoreParticles = true
    
    var body: some View {
        ZStack {
            overlayView
                .opacity(onFinish ? 0 : 1)
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: OverlayImagePreferenceKey.self, value: geometry.frame(in: .local))
                })
            
            content
                .mask(
                    ZStack {
                        if !onFinish {
                            ScratchMask(strokes: strokes)
                                .stroke(style: StrokeStyle(lineWidth: cursorSize, lineCap: .round, lineJoin: .round))
                        } else {
                            Rectangle()
                        }
                    }
                )
                .animation(.easeInOut, value: onFinish)
                .gesture(
                    DragGesture()
                        .updating($gestureLocation, body: { value, out, _ in
                            out = value.location
                            DispatchQueue.main.async {
                                let canvasSize = CGSize(width: 300, height: 300)
                                if value.location.x >= 0 && value.location.x < canvasSize.width &&
                                   value.location.y >= 0 && value.location.y < canvasSize.height {
                                    if strokes.last?.isEmpty == true {
                                        strokes[strokes.count - 1].append(value.location)
                                    } else {
                                        strokes[strokes.count - 1].append(value.location)
                                    }
                                    if allowGeneratingMoreParticles {
                                        generateDirtParticles(around: value.location, in: canvasSize)
                                    }
                                    removeDirtParticles(under: value.location)
                                }
                            }
                        })
                        .onEnded({ value in
                            let canvasSize = CGSize(width: 300, height: 300)
                            let scratchedPercentage = calculateScratchedPercentage(strokes: strokes, cursorSize: cursorSize, canvasSize: canvasSize)
                            if scratchedPercentage > 0.5 { /// Card percentage scratched beforte it is automatically discovered/cleaned
                                
                                /// First time the card is cleaned, we remove most of the particles to allow the user reading/seeing the message.
                                /// After this time, the user will be only allowed to remove the particles that are already displayed
                                if allowGeneratingMoreParticles {
                                    dirtParticles = Array(dirtParticles.prefix(dirtParticles.count / 5))
                                }
                                allowGeneratingMoreParticles = false
                                withAnimation(.easeInOut) {
                                    onFinish = true
                                }
                                
                            } else {
                                strokes.append([])
                            }
                        })
                )
            
            // Añadir partículas de suciedad alrededor del trazo
            DirtParticlesView(dirtParticles: dirtParticles)
                .frame(width: 300, height: 300)
                .allowsHitTesting(false)
        }
        .frame(width: 300, height: 300)
        .cornerRadius(20)
        .onPreferenceChange(OverlayImagePreferenceKey.self) { value in
            if let frame = value {
                overlayImageFrame = frame
            }
        }
        .onChange(of: onFinish) { oldValue, value in
            if (!onFinish && !strokes.isEmpty) {
                withAnimation(.easeInOut) {
                    resetView()
                }
            }
        }
    }
    
    private func resetView() {
        strokes.removeAll()
        strokes.append([])
        dirtParticles.removeAll()
    }
    
    private func calculateScratchedPercentage(strokes: [[CGPoint]], cursorSize: CGFloat, canvasSize: CGSize) -> CGFloat {
        let bitmapWidth = Int(canvasSize.width)
        let bitmapHeight = Int(canvasSize.height)
        let bytesPerPixel = 4
        let bitmapBytesPerRow = bitmapWidth * bytesPerPixel
        
        var bitmapData = [UInt8](repeating: 0, count: bitmapWidth * bitmapHeight * bytesPerPixel)
        
        for stroke in strokes {
            for point in stroke {
                let x = Int(point.x)
                let y = Int(point.y)
                
                let minX = max(0, x - Int(cursorSize / 2))
                let maxX = min(bitmapWidth - 1, x + Int(cursorSize / 2))
                let minY = max(0, y - Int(cursorSize / 2))
                let maxY = min(bitmapHeight - 1, y + Int(cursorSize / 2))
                
                for i in minX...maxX {
                    for j in minY...maxY {
                        let offset = (j * bitmapWidth + i) * bytesPerPixel
                        bitmapData[offset] = 255
                        bitmapData[offset + 1] = 255
                        bitmapData[offset + 2] = 255
                        bitmapData[offset + 3] = 255
                    }
                }
            }
        }
        
        let totalPixels = bitmapWidth * bitmapHeight
        let scratchedPixels = bitmapData.filter { $0 == 255 }.count / bytesPerPixel
        
        return CGFloat(scratchedPixels) / CGFloat(totalPixels)
    }
    
    /// - Description: Used to generate random particles around the scratched path
    private func generateDirtParticles(around point: CGPoint, in canvasSize: CGSize) {
        guard let overlayImage = overlayImage else { return }
        
        let scaledX = point.x / canvasSize.width * overlayImage.size.width
        let scaledY = point.y / canvasSize.height * overlayImage.size.height
        let pointInOverlay = CGPoint(x: scaledX, y: scaledY)
        
        if let color = overlayImage.getPixelColor(at: pointInOverlay) {
            
            for _ in 0..<5 {
                let randomXOffset = CGFloat.random(in: -20...20)
                let randomYOffset = CGFloat.random(in: -20...20)
                let dirtPoint = CGPoint(x: point.x + randomXOffset, y: point.y + randomYOffset)
                let darkerColor = color.darker(by: 0.3)
                let newParticle = DirtParticle(position: dirtPoint, color: darkerColor)
                if !isPointInStrokes(point: dirtPoint) {
                    dirtParticles.append(newParticle)
                }
            }
        }
    }
    
    /// - Description: Used to remove already existing particles when the user drags/scratches on their position
    private func removeDirtParticles(under point: CGPoint) {
        dirtParticles.removeAll { dirtParticle in
            abs(dirtParticle.position.x - point.x) < cursorSize && abs(dirtParticle.position.y - point.y) < cursorSize
        }
    }
    
    private func isPointInStrokes(point: CGPoint) -> Bool {
        for stroke in strokes {
            for strokePoint in stroke {
                if abs(strokePoint.x - point.x) < cursorSize / 2 && abs(strokePoint.y - point.y) < cursorSize / 2 {
                    return true
                }
            }
        }
        return false
    }
    
    /// - Description: Gets the color from the image pixel in the selected position
//    private func getPixelColor(at point: CGPoint, from image: UIImage) -> Color {
//        guard let cgImage = image.cgImage,
//              let dataProvider = cgImage.dataProvider,
//              let data = dataProvider.data,
//              let bytes = CFDataGetBytePtr(data) else { return Color.gray }
//        let bytesPerPixel = 4
//        let bytesPerRow = cgImage.bytesPerRow
//        let byteIndex = Int(point.y) * bytesPerRow + Int(point.x) * bytesPerPixel
//        
//        let r = CGFloat(bytes[byteIndex]) / 255.0
//        let g = CGFloat(bytes[byteIndex + 1]) / 255.0
//        let b = CGFloat(bytes[byteIndex + 2]) / 255.0
//        let a = CGFloat(bytes[byteIndex + 3]) / 255.0
//        
//        return Color(red: r, green: g, blue: b, opacity: a)
//    }
}
