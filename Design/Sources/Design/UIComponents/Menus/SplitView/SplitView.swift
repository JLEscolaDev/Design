//
//  Orientation.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//
// ViewModifier personalizado para detectar rotación
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                // Forzar una comprobación de orientación con un pequeño retraso para asegurar el valor correcto
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    action(UIDevice.current.orientation)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// Extensión de View para simplificar el uso del ViewModifier
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}


import SwiftUI

struct SplitView<TopContent: View, BottomContent: View>: View {
//    @State var firstViewHeight: CGFloat = 0
//    @State var firstViewWidth: CGFloat = 0
//    private let forceOrientation: Bool
    @State private var deviceOrientation: Orientation
    
    /// - Parameter orientation: Set this parameter if you want to force an orentation instead of using the device automatic orientation
    init(orientation: Orientation? = nil, topContent: TopContent, bottomContent: BottomContent, minSize: CGFloat = 100) {
        self.topContent = topContent
        self.bottomContent = bottomContent
//        self.forceOrientation = orientation != nil
        self.orientation = orientation
        self.deviceOrientation = orientation ?? .vertical
        self.minSize = minSize
    }
    
    @State private var orientation: Orientation?
    @State private var dragState = DragState.inactive
    
    /// The minimum size (width or height, depending of horizontal or vertical orientation) that views will have
    let minSize: CGFloat
    let snapThreshold: CGFloat = 50

    let topContent: TopContent
    let bottomContent: BottomContent
    
    var body: some View {
        GeometryReader { geometry in
            let size = deviceOrientation == .vertical ? geometry.size.height : geometry.size.width
//            let firstViewSize = deviceOrientation == .vertical ? firstViewHeight : firstViewWidth
//            print( "width: \(geometry.size.width - firstViewWidth - 30),height: \(firstViewHeight)")
            let firstViewSizes = firstSizes(for: geometry)
            let secondViewSizes = secondSizes(for: geometry)
            
            VariableOrientationStack(orientation: variableOrientation) {
                topContent
                    .frame(
                        width: firstViewSizes.width,
                        height: firstViewSizes.height
                    )
                
                VariableOrientationStack(orientation: variableOrientation) {
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: dragIndicatorSize.width, height: dragIndicatorSize.height)
                        .scaleEffect(dragState.isDragging ? 0.8 : 1.0)
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(.horizontal, deviceOrientation == .horizontal ? 10 : 3)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
//                                    self.dragState = .dragging(translation: gesture.translation)
//                                    let dragAmount = deviceOrientation == .horizontal ? gesture.translation.width : gesture.translation.height
//                                    
//                                    let newSize = max(minSize, min(size - minSize, firstViewSize + dragAmount))
//                                    
//                                    if newSize != firstViewSize {
//                                        updateFirstViewSize(with: newSize)
//                                    }
                                }
                                .onEnded { _ in
//                                    self.dragState = .inactive
//                                    withAnimation(.spring()) {
//                                        let variableSizeToCompare = deviceOrientation == .vertical ? firstViewHeight : firstViewWidth
//                                        if firstViewSize < minSize + snapThreshold {
//                                            updateFirstViewSize(with: minSize)
//                                            
//                                        } else if (size - variableSizeToCompare) < minSize + snapThreshold {
//                                            updateFirstViewSize(with: size - minSize)
//                                        }
//                                    }
                                }
                        )
                    Spacer()
                }

                bottomContent
                    .frame(
                        width: secondViewSizes.width,
                        height: secondViewSizes.height
                    )
            }
//            .onAppear {
//                updateFirstViewSizes(width: geometry.size.width, height: geometry.size.height)
//            }
            .onRotate { newOrientation in
//                print(newOrientation.isLandscape)
                    deviceOrientation = newOrientation.isLandscape ? .horizontal : .vertical
                    //                if !forceOrientation {
//                    updateFirstViewSizes(width: geometry.size.width, height: geometry.size.height)
//                print("Orientation: \(orientation), deviceOrientation: \(deviceOrientation)")
//                print("firstWidth: \(firstWidth), firstHeight: \(firstHeight)")
//                }
//                else {
//                    if orientation == .vertical {
//                        updateFirstViewSizes(width: geometry.size.width, height: geometry.size.height)
//                    } else {
//                        updateFirstViewSizes(width: geometry.size.height, height: geometry.size.width)
//                    }
//                }
            }
        }
//        .ignoresSafeArea()
        .background(.black)
    }
    
    private var variableOrientation: Orientation {
        switch (orientation, deviceOrientation) {
            case (nil, _):
                deviceOrientation == .vertical ? .horizontal : .vertical
            case (.horizontal, _):
                .vertical
            case (.vertical, _):
                .horizontal
        }
    }
    
    private func firstSizes(for geometry: GeometryProxy) -> (width: CGFloat, height: CGFloat) {
        switch (orientation, deviceOrientation) {
            case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
                (geometry.size.width/2 - 15, geometry.size.height)
            case (.vertical, .horizontal):
                (geometry.size.height, geometry.size.width/2 - 15)
            case (.horizontal, .vertical):
                (geometry.size.width, geometry.size.height/2 - 15)
        }
    }
    
    private func secondSizes(for geometry: GeometryProxy) -> (width: CGFloat, height: CGFloat) {
        let firstViewSizes = firstSizes(for: geometry)
        let firstWidth = firstViewSizes.width
        let firstHeight = firstViewSizes.height
        
        return switch (orientation, deviceOrientation) {
            case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
                (geometry.size.width - firstWidth - 15, firstHeight)
            case (.vertical, .horizontal):
                (geometry.size.height, geometry.size.width - firstWidth - 15)
            case (.horizontal, .vertical):
                (geometry.size.width, geometry.size.height - firstHeight - 15)
        }
    }
    
    private var dragIndicatorSize: CGSize {
        switch (orientation, deviceOrientation) {
            case (nil, _):
                CGSize(width: 10, height: 50)
            case (.vertical, .vertical), (.horizontal, .horizontal), (.vertical, .horizontal):
                CGSize(width: 10, height: 50)
            case (.horizontal, .vertical):
                CGSize(width: 50, height: 10)
        }
    }
    
//    private func updateFirstViewSizes(width: CGFloat, height: CGFloat) {
////        print(orientation)
////        print("width: \(width), height: \(height)")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            firstViewWidth = width/2
//            firstViewHeight = height
//        }
//    }
//    
//    private func updateFirstViewSize(with newSize: CGFloat) {
//        print(newSize)
//        if orientation == .vertical {
//            firstViewHeight = newSize
//        }else {
//            firstViewWidth = newSize
//        }
//    }
}



//import SwiftUI
//
//struct SplitView<TopContent: View, BottomContent: View>: View {
////    @State var firstViewHeight: CGFloat = 0
////    @State var firstViewWidth: CGFloat = 0
////    private let forceOrientation: Bool
//    @State private var deviceOrientation: Orientation
//    
//    /// - Parameter orientation: Set this parameter if you want to force an orentation instead of using the device automatic orientation
//    init(orientation: Orientation? = nil, topContent: TopContent, bottomContent: BottomContent, minSize: CGFloat = 100) {
//        self.topContent = topContent
//        self.bottomContent = bottomContent
////        self.forceOrientation = orientation != nil
//        self.orientation = orientation
//        self.deviceOrientation = orientation ?? .vertical
//        self.minSize = minSize
//    }
//    
//    @State private var orientation: Orientation?
//    @State private var dragState = DragState.inactive
//    @State private var firstViewSizeModifier: CGFloat = 0
//    
//    /// The minimum size (width or height, depending of horizontal or vertical orientation) that views will have
//    let minSize: CGFloat
//    let snapThreshold: CGFloat = 50
//
//    let topContent: TopContent
//    let bottomContent: BottomContent
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let size = deviceOrientation == .vertical ? geometry.size.height : geometry.size.width
////            let firstViewSize = deviceOrientation == .vertical ? firstViewHeight : firstViewWidth
////            print( "width: \(geometry.size.width - firstViewWidth - 30),height: \(firstViewHeight)")
//            let firstViewSizes = firstSizes(for: geometry)
//            let secondViewSizes = secondSizes(for: geometry)
//            
//            VariableOrientationStack(orientation: variableOrientation) {
//                topContent
//                    .frame(
//                        width: firstViewSizes.width,
//                        height: firstViewSizes.height
//                    )
//                
//                VariableOrientationStack(orientation: variableOrientation) {
//                    Spacer()
//                    RoundedRectangle(cornerRadius: 10)
//                        .frame(width: dragIndicatorSize.width, height: dragIndicatorSize.height)
//                        .scaleEffect(dragState.isDragging ? 0.8 : 1.0)
//                        .foregroundColor(.gray.opacity(0.4))
//                        .padding(.horizontal, deviceOrientation == .horizontal ? 10 : 3)
//                        .gesture(
//                            DragGesture()
//                                .onChanged { gesture in
//                                    self.dragState = .dragging(translation: gesture.translation)
//                                    
//                                    let /*(*/dragAmount/*, firstViewSize)*/ = switch (orientation, deviceOrientation) {
////                                        case (nil, .horizontal):
////                                        /*(*/gesture.translation.width/*, firstViewSizes.width)*/
////                                        case (nil, .vertical):
////                                        /*(*/gesture.translation.width/*, firstViewSizes.width)*/
//                                        case (.horizontal, .vertical):
//                                            /*(*/gesture.translation.height/*, firstViewSizes.height)*/
//                                        case (.vertical, .horizontal):
//                                        /*(*/gesture.translation.width/*, firstViewSizes.width)*/
//                                        default:
//                                            gesture.translation.width
//                                    }
////                                    let dragAmount = deviceOrientation == .horizontal ? gesture.translation.width : gesture.translation.height
//                                    
////                                    let newSize = max(minSize, min(size - minSize, firstViewSize + dragAmount))
//                                    
////                                    if newSize != firstViewSize {
//                                        firstViewSizeModifier = dragAmount
////                                        updateFirstViewSize(with: newSize)
////                                    }
//                                }
//                                .onEnded { _ in
//                                    self.dragState = .inactive
////                                    withAnimation(.spring()) {
////                                        let variableSizeToCompare = deviceOrientation == .vertical ? firstViewHeight : firstViewWidth
////                                        if firstViewSize < minSize + snapThreshold {
////                                            updateFirstViewSize(with: minSize)
////
////                                        } else if (size - variableSizeToCompare) < minSize + snapThreshold {
////                                            updateFirstViewSize(with: size - minSize)
////                                        }
////                                    }
//                                }
//                        )
//                    Spacer()
//                }
//
//                bottomContent
//                    .frame(
//                        width: secondViewSizes.width,
//                        height: secondViewSizes.height
//                    )
//            }
////            .onAppear {
////                updateFirstViewSizes(width: geometry.size.width, height: geometry.size.height)
////            }
//            .onRotate { newOrientation in
////                print(newOrientation.isLandscape)
//                    deviceOrientation = newOrientation.isLandscape ? .horizontal : .vertical
//                    //                if !forceOrientation {
////                    updateFirstViewSizes(width: geometry.size.width, height: geometry.size.height)
////                print("Orientation: \(orientation), deviceOrientation: \(deviceOrientation)")
////                print("firstWidth: \(firstWidth), firstHeight: \(firstHeight)")
////                }
////                else {
////                    if orientation == .vertical {
////                        updateFirstViewSizes(width: geometry.size.width, height: geometry.size.height)
////                    } else {
////                        updateFirstViewSizes(width: geometry.size.height, height: geometry.size.width)
////                    }
////                }
//            }
//        }
////        .ignoresSafeArea()
//        .background(.black)
//    }
//    
//    private var variableOrientation: Orientation {
//        switch (orientation, deviceOrientation) {
//            case (nil, _):
//                deviceOrientation == .vertical ? .horizontal : .vertical
//            case (.horizontal, _):
//                .vertical
//            case (.vertical, _):
//                .horizontal
//        }
//    }
//    
////    private func firstSizes(for geometry: GeometryProxy) -> (width: CGFloat, height: CGFloat) {
////        let size = deviceOrientation == .vertical ? geometry.size.height : geometry.size.width
////
////        return switch (orientation, deviceOrientation) {
////            case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
////            var w:CGFloat = 0
////            var h:CGFloat = 0
////            if deviceOrientation == .vertical {
////                w = geometry.size.width
////                h = max(minSize, min(size - minSize, (geometry.size.height/2 - 15) + firstViewSizeModifier))
//////                return (w, h)
////            } else {
////                w = max(minSize, min(size - minSize, geometry.size.height + firstViewSizeModifier))
////                h = geometry.size.width/2 - 15
////
////            }
////            return (w, h)
//////            let width = geometry.size.width/2 - 15
//////            let height = geometry.size.height
//////
//////                (geometry.size.width/2 - 15, geometry.size.height)
////            case (.vertical, .horizontal):
////                let width = max(minSize, min(size - minSize, geometry.size.height + firstViewSizeModifier))
////                let height = geometry.size.width/2 - 15
////            return (width, height)
//////                (geometry.size.height, geometry.size.width/2 - 15)
////            case (.horizontal, .vertical):
//////                (geometry.size.width, geometry.size.height/2 - 15)
////            let width = geometry.size.width
////            let height = max(minSize, min(size - minSize, (geometry.size.height/2 - 15) + firstViewSizeModifier))
////            return (width, height)
////        }
//////        let newSize = max(minSize, min(size - minSize, deviceOrientation == .vertical ? height  + firstViewSizeModifier : width + firstViewSizeModifier))
////    }
//    
//    private func firstSizes(for geometry: GeometryProxy) -> (width: CGFloat, height: CGFloat) {
//        let size = deviceOrientation == .vertical ? geometry.size.height : geometry.size.width
//
//        switch (orientation, deviceOrientation) {
//        case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
//            let width: CGFloat
//            let height: CGFloat
//
//            if deviceOrientation == .vertical {
//                width = geometry.size.width
//                height = max(minSize, min(size - minSize, (geometry.size.height / 2 - 15) + firstViewSizeModifier))
//            } else {
//                width = max(minSize, min(size - minSize, geometry.size.height + firstViewSizeModifier))
//                height = geometry.size.width / 2 - 15
//            }
//            return (width, height)
//
//        case (.vertical, .horizontal):
//            let width = max(minSize, min(size - minSize, geometry.size.height + firstViewSizeModifier))
//            let height = geometry.size.width / 2 - 15
//            return (width, height)
//
//        case (.horizontal, .vertical):
//            let width = geometry.size.width
//            let height = max(minSize, min(size - minSize, (geometry.size.height / 2 - 15) + firstViewSizeModifier))
//            return (width, height)
//
//        default:
//            fatalError("Unsupported orientation combination")
//        }
//    }
//    
//    private func secondSizes(for geometry: GeometryProxy) -> (width: CGFloat, height: CGFloat) {
//        let firstViewSizes = firstSizes(for: geometry)
//        let firstWidth = firstViewSizes.width
//        let firstHeight = firstViewSizes.height
//        
//        return switch (orientation, deviceOrientation) {
//            case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
//                (geometry.size.width - firstWidth - 15, firstHeight)
//            case (.vertical, .horizontal):
//                (geometry.size.height, geometry.size.width - firstWidth - 15)
//            case (.horizontal, .vertical):
//                (geometry.size.width, geometry.size.height - firstHeight - 15)
//        }
//    }
//    
//    private var dragIndicatorSize: CGSize {
//        switch (orientation, deviceOrientation) {
//            case (nil, _):
//                CGSize(width: 10, height: 50)
//            case (.vertical, .vertical), (.horizontal, .horizontal), (.vertical, .horizontal):
//                CGSize(width: 10, height: 50)
//            case (.horizontal, .vertical):
//                CGSize(width: 50, height: 10)
//        }
//    }
//    
////    private func updateFirstViewSizes(width: CGFloat, height: CGFloat) {
//////        print(orientation)
//////        print("width: \(width), height: \(height)")
////        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
////            firstViewWidth = width/2
////            firstViewHeight = height
////        }
////    }
////
////    private func updateFirstViewSize(with newSize: CGFloat) {
////        print(newSize)
////        if orientation == .vertical {
////            firstViewHeight = newSize
////        }else {
////            firstViewWidth = newSize
////        }
////    }
//}



// - MARK: PREVIEW

#Preview {
    SplitViewPreview().ignoresSafeArea()
}

@_spi(Demo) public struct SplitViewPreview: View {
    public init() {}
    private let orientation: Orientation? = .horizontal
    private let minSize: CGFloat = 100
    
    public var body: some View {
        GeometryReader { geometry in
            SplitView(
                orientation: orientation,
                topContent:
                    Color.orange
//                    TopView(
//                        orientation: orientation,
//                        minSize: minSize
//                    ).font(.system(size: 16,weight: .medium, design: .rounded))
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    .orange,
                                    .yellow
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    ),
                bottomContent:
                    ZStack {
                        Color.blue
                        Text("Esto es un text")
                    }
//                    BottomView(
//                        orientation: orientation,
//                        minSize: minSize
//                    ).font(.system(size: 16,weight: .medium,design: .rounded))
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    .cyan,
                                    .blue
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    )
                ,
                minSize: minSize
            )
        }
    }
    
}

