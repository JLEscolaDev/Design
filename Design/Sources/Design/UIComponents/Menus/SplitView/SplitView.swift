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

@Observable
public class SplitViewModel<TopContent: View, BottomContent: View> {
    var deviceOrientation: Orientation
    
    /// - Parameter orientation: Set this parameter if you want to force an orentation instead of using the device automatic orientation
    public init(orientation: Orientation? = nil, topContent: TopContent, bottomContent: BottomContent, minSize: CGFloat = 100) {
        self.topContent = topContent
        self.bottomContent = bottomContent
//        self.forceOrientation = orientation != nil
        self.orientation = orientation
        self.deviceOrientation = orientation ?? .vertical
        self.minSize = minSize
    }
    
    @ObservationIgnored var orientation: Orientation?
    var dragState = DragState.inactive
    var translation: CGSize = .zero
    
    /// The minimum size (width or height, depending of horizontal or vertical orientation) that views will have
    let minSize: CGFloat
    let snapThreshold: CGFloat = 100
    @ObservationIgnored var isSnapped: Bool = false

    let topContent: TopContent
    let bottomContent: BottomContent
    
    @ObservationIgnored var firstViewSizes: (width: CGFloat, height: CGFloat) = (0, 0)
    @ObservationIgnored var secondViewSizes: (width: CGFloat, height: CGFloat) = (0, 0)
}

import SwiftUI

public struct SplitView<TopContent: View, BottomContent: View>: View {
    public init(vm: SplitViewModel<TopContent, BottomContent>) {
        self.vm = vm
    }
    
    
    @State private var vm: SplitViewModel<TopContent, BottomContent>
//    @State var firstViewHeight: CGFloat = 0
//    @State var firstViewWidth: CGFloat = 0
//    private let forceOrientation: Bool
//    @State private var deviceOrientation: Orientation
//
//    /// - Parameter orientation: Set this parameter if you want to force an orentation instead of using the device automatic orientation
//    public init(orientation: Orientation? = nil, topContent: TopContent, bottomContent: BottomContent, minSize: CGFloat = 100) {
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
//
//    /// The minimum size (width or height, depending of horizontal or vertical orientation) that views will have
//    let minSize: CGFloat
//    let snapThreshold: CGFloat = 50
//
//    let topContent: TopContent
//    let bottomContent: BottomContent
    
    public var body: some View {
        GeometryReader { geometry in
            let size = vm.deviceOrientation == .vertical ? geometry.size.height : geometry.size.width
//            let firstViewSize = deviceOrientation == .vertical ? firstViewHeight : firstViewWidth
//            print( "width: \(geometry.size.width - firstViewWidth - 30),height: \(firstViewHeight)")
//            let firstViewSizes = firstSizes(for: geometry)
//            let secondViewSizes = secondSizes(for: geometry)
            calculateViewSizes(for: geometry)
            
            return VariableOrientationStack(orientation: variableOrientation) {
                vm.topContent
                    .frame(
                        width: vm.firstViewSizes.width,
                        height: vm.firstViewSizes.height
                    )
                
                VariableOrientationStack(orientation: variableOrientation) {
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: dragIndicatorSize.width, height: dragIndicatorSize.height)
                        .scaleEffect(vm.dragState.isDragging ? 0.8 : 1.0)
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(.horizontal, vm.deviceOrientation == .horizontal ? 10 : 3)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
//                                    if vm.dragState.isDragging {
                                    vm.dragState = .dragging
                                switch (vm.orientation, vm.deviceOrientation) {
                                case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
                                    
                                    switch vm.deviceOrientation {
                                        case .vertical:
                                            if vm.firstViewSizes.height + gesture.translation.height > vm.minSize - 15,
                                               vm.firstViewSizes.height + gesture.translation.height < geometry.size.height - vm.minSize - 15 {
                                                vm.translation.height += gesture.translation.height
                                            }
                                            vm.translation.width += gesture.translation.width
                                            break
                                        case .horizontal:
                                            if vm.firstViewSizes.width + gesture.translation.width > vm.minSize - 15,
                                               vm.firstViewSizes.width + gesture.translation.width < geometry.size.width - vm.minSize - 15 {
                                                vm.translation.width += gesture.translation.width
                                            }
                                            vm.translation.height += gesture.translation.height
                                    }
                                case (.vertical, .horizontal):
                                        if vm.firstViewSizes.width + gesture.translation.width > vm.minSize - 15,
                                           vm.firstViewSizes.width + gesture.translation.width < geometry.size.width - vm.minSize - 15 {
                                            vm.translation.width += gesture.translation.width
                                        }
                                        vm.translation.height += gesture.translation.height
                                case (.horizontal, .vertical):
                                        if vm.firstViewSizes.width + gesture.translation.width > vm.minSize - 15,
                                           vm.firstViewSizes.width + gesture.translation.width < geometry.size.width - vm.minSize - 15 {
                                            vm.translation.width += gesture.translation.width
                                        }
                                        vm.translation.height += gesture.translation.height
//                                    finalWidth = ensureMinSize(width, maxViewSize: geometry.size.width)
//                                    finalHeight = height
                            }
                                    
//                                        vm.translation.width += gesture.translation.width
//                                        vm.translation.height += gesture.translation.height
//                                    } else {
//                                        vm.dragState = .dragging
//                                        vm.translation.width = gesture.translation.width
//                                        vm.translation.height = gesture.translation.height
//                                    }
//                                    print("\(gesture.translation.width), < \(vm.translation.width)")
//                                    vm.dragState = .dragging
//                                    vm.translation.width += gesture.translation.width < vm.translation.width ? -abs(gesture.translation.width) : abs(gesture.translation.width)
//                                    vm.translation.height += gesture.translation.height < vm.translation.height ? gesture.translation.height : abs(gesture.translation.height)
//                                    vm.translation.width = gesture.translation.width
//                                    vm.translation.height = gesture.translation.height
                                    
//                                    print("\(gesture.translation.width), \(gesture.translation.height)")
//                                    var newTranslation = vm.dragState.translation
//                                    newTranslation.height += gesture.translation.height
//                                    newTranslation.width += gesture.translation.width
//                                    vm.dragState = .dragging(translation: newTranslation)
//                                    let dragAmount = deviceOrientation == .horizontal ? gesture.translation.width : gesture.translation.height
//
//                                    let newSize = max(minSize, min(size - minSize, firstViewSize + dragAmount))
//
//                                    if newSize != firstViewSize {
//                                        updateFirstViewSize(with: newSize)
//                                    }
                                }
                                .onEnded { gesture in
                                    vm.dragState = .inactive
                                    
                                    let minSize = vm.minSize - 15
                                    let snapThreshold = minSize + vm.snapThreshold
                                    withAnimation(.bouncy) {
                                switch (vm.orientation, vm.deviceOrientation) {
                                case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
                                    
                                    switch vm.deviceOrientation {
                                        case .vertical:
                                            
                                                if vm.firstViewSizes.height + gesture.translation.height < snapThreshold {
                                                    vm.translation.height = -geometry.size.height/2 + minSize
                                                    
                                                } else if vm.firstViewSizes.height >= geometry.size.height - snapThreshold {
                                                    vm.translation.height =  geometry.size.height/2 - minSize
                                                }
                                        case .horizontal:
                                            if vm.firstViewSizes.width + gesture.translation.width < snapThreshold {
                                                vm.translation.width = -geometry.size.width/2 + minSize
                                                
                                            } else if vm.firstViewSizes.width >= geometry.size.width - snapThreshold {
                                                vm.translation.width =  geometry.size.width/2 - minSize
                                            }
                                    }
                                case (.vertical, .horizontal):
                                        if vm.firstViewSizes.height + gesture.translation.height < snapThreshold {
                                            vm.translation.height = -geometry.size.height/2 + minSize
                                            
                                        } else if vm.firstViewSizes.height >= geometry.size.height - snapThreshold {
                                            vm.translation.height =  geometry.size.height/2 - minSize
                                        }
                                case (.horizontal, .vertical):
                                        if vm.firstViewSizes.width + gesture.translation.width < snapThreshold {
                                            vm.translation.width = -geometry.size.width/2 + minSize
                                            
                                        } else if vm.firstViewSizes.width >= geometry.size.width - snapThreshold {
                                            vm.translation.width =  geometry.size.width/2 - minSize
                                        }
//                                    finalWidth = ensureMinSize(width, maxViewSize: geometry.size.width)
//                                    finalHeight = height
                            }
                                        
                                    }
//                                    withAnimation(.spring()) {
//                                        let variableSizeToCompare = vm.deviceOrientation == .vertical ? firstViewSizes.height : firstViewSizes.width
//                                        if firstViewSize < vm.minSize + vm.snapThreshold {
//                                            updateFirstViewSize(with: vm.minSize)
//
//                                        } else if (size - variableSizeToCompare) < vm.minSize + vm.snapThreshold {
//                                            updateFirstViewSize(with: size - vm.minSize)
//                                        }
//                                    }
                                }
                        )
                    Spacer()
                }

                vm.bottomContent
                    .frame(
                        width: vm.secondViewSizes.width,
                        height: vm.secondViewSizes.height
                    )
            }
//            .onAppear {
//                updateFirstViewSizes(width: geometry.size.width, height: geometry.size.height)
//            }
            .onRotate { newOrientation in
//                print(newOrientation.isLandscape)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let orientation: Orientation = newOrientation.isLandscape ? .horizontal : .vertical
                if orientation != vm.deviceOrientation {
                    vm.deviceOrientation = orientation
                    vm.translation = .zero
                }
                
//                    print(vm.orientation, vm.deviceOrientation)
//                }
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
        switch (vm.orientation, vm.deviceOrientation) {
//            case (nil, _):
//                vm.deviceOrientation == .vertical ? .horizontal : .vertical
            case (.vertical, .vertical), (.vertical, .horizontal), (nil, .vertical):
                .vertical
            case (.horizontal, .vertical), (.vertical, .vertical), (.horizontal, .horizontal), (nil, .horizontal):
                .horizontal
        }
    }
    
//    private var dragIndicatorOrientation: Orientation {
//        switch (vm.orientation, vm.deviceOrientation) {
//            case (nil, _):
//                vm.deviceOrientation == .vertical ? .horizontal : .vertical
//            case (.vertical, .horizontal), (.horizontal, .horizontal):
//                .vertical
//            case (.horizontal, .vertical), (.vertical, .vertical):
//                .horizontal
//        }
//    }
    
    private func calculateViewSizes(for geometry: GeometryProxy) {
        if vm.isSnapped {
            print("Animated")
            withAnimation(.bouncy) {
                firstSizes(for: geometry)
                secondSizes(for: geometry)
            }
        } else {
            firstSizes(for: geometry)
            secondSizes(for: geometry)
        }
        vm.isSnapped = false
    }
    
    private func firstSizes(for geometry: GeometryProxy) {
        var finalWidth = CGFloat.zero
        var finalHeight = CGFloat.zero
        
        switch (vm.orientation, vm.deviceOrientation) {
            case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
                
                switch vm.deviceOrientation {
                    case .vertical:
                        let width = geometry.size.width
                        let height = geometry.size.height/2 - 15
//                        print("width: \(width+dragState.translation.width), height: \(height)")
//                        finalWidth = width
//                        finalHeight = height+vm.translation.height
                        vm.firstViewSizes = (width, height+vm.translation.height)
                    case .horizontal:
                        let width = geometry.size.width/2 - 15
                        let height = geometry.size.height
//                        print("width: \(width+dragState.translation.width), height: \(height)")
//                        return (width+vm.translation.width, height)
//                        finalWidth = width+vm.translation.width
//                        finalHeight = height
                        vm.firstViewSizes = (width+vm.translation.width, height)
                }
//                (geometry.size.width/2 - 15, geometry.size.height)
            case (.vertical, .horizontal):
                let width = geometry.size.width
                let height = geometry.size.height/2 - 15+vm.translation.height
//                finalWidth = width
//                finalHeight = height
                vm.firstViewSizes = (width, height)
//                switch deviceOrientation {
//                    case .vertical:
//                        (width, height)
//                    case .horizontal:
//                        (height, width)
//                }
//                (geometry.size.height, geometry.size.width/2 - 15)
            case (.horizontal, .vertical):
                let width = geometry.size.width/2 + vm.translation.width
                let height = geometry.size.height
//                let width = geometry.size.width
//                let height = geometry.size.height/2 - 15+vm.translation.height
//                finalWidth = width
//                finalHeight = height
                vm.firstViewSizes = (width, height)
//                (geometry.size.width, geometry.size.height/2 - 15)
        }
//        return (finalWidth, finalHeight)
    }
    
//    private func ensureMinSize(_ value: CGFloat, maxViewSize: CGFloat) -> CGFloat {
////        print(value)
//        // Check if the value is within the valid range
////        return value
//        return if value >= vm.minSize && value <= maxViewSize - vm.minSize - 30 {
//            value
//        } else {
//            // Determine the closest boundary (minSize or maxSize)
//            if abs(value - vm.minSize) < abs(value - (maxViewSize - vm.minSize)) {
//                
//                vm.minSize-30
//            } else {
//                maxViewSize - vm.minSize
//            }
//        }
//    }
    
    private func secondSizes(for geometry: GeometryProxy) {
        let firstWidth = vm.firstViewSizes.width
        let firstHeight = vm.firstViewSizes.height
        
        return switch (vm.orientation, vm.deviceOrientation) {
            case (.horizontal, .horizontal):
                vm.secondViewSizes = (geometry.size.width - firstWidth - 15, firstHeight)
            case (.vertical, .horizontal), (.vertical, .vertical), (nil, .vertical) :
                vm.secondViewSizes = (firstWidth, geometry.size.height - firstHeight - 15)
            case (.horizontal, .vertical), (nil, .horizontal):
//                (geometry.size.width, geometry.size.height - firstHeight - 15)
                vm.secondViewSizes = (geometry.size.width - firstWidth - 15, firstHeight)
        }
    }
    
    private var dragIndicatorSize: CGSize {
        switch (vm.orientation, vm.deviceOrientation) {
            case (.horizontal, .horizontal), (.horizontal, .vertical), (nil, .horizontal):
                CGSize(width: 10, height: 50)
            case (.vertical, .vertical), (.vertical, .horizontal), (nil, .vertical):
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
    private let orientation: Orientation? = nil
    private let minSize: CGFloat = 100
    
    public var body: some View {
        GeometryReader { geometry in
            SplitView(vm: .init(
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
            ))
        }
    }
    
}

import SwiftUI

// Enum para definir la posición de la muesca
enum NotchPosition {
    case left
    case right
    case top
    case bottom
}

// OptionSet para los lados permitidos
struct NotchSides: OptionSet {
    let rawValue: Int

    static let left   = NotchSides(rawValue: 1 << 0)
    static let right  = NotchSides(rawValue: 1 << 1)
    static let top    = NotchSides(rawValue: 1 << 2)
    static let bottom = NotchSides(rawValue: 1 << 3)

    static let all: NotchSides = [.left, .right, .top, .bottom]
}

struct NotchedShape: Shape {
    var deformation: CGFloat // Profundidad de la muesca
    var notchPosition: CGFloat // Posición de la muesca (horizontal o vertical)
    var side: NotchPosition // Lado de la muesca

    // Animamos tanto la deformación como la posición de la muesca
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(deformation, notchPosition) }
        set {
            deformation = newValue.first
            notchPosition = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Dimensiones de la muesca
        let notchSize = deformation // Tamaño de la muesca (ancho o alto, dependiendo del lado)
        let notchLength = (side == .left || side == .right) ? rect.height * 0.3 : rect.width * 0.3 // Longitud de la muesca
        let cornerRadius = deformation * 0.7 // Radio de las esquinas redondeadas

        switch side {
        case .left, .right:
            // Aseguramos que la posición de la muesca esté dentro de los límites verticales
            let notchY = max(rect.minY + notchLength / 2, min(notchPosition, rect.maxY - notchLength / 2))
            let notchStartY = notchY - notchLength / 2
            let notchEndY = notchY + notchLength / 2

            if side == .left {
                // Muesca en el lado izquierdo
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: notchStartY - cornerRadius))

                // Esquina superior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + cornerRadius, y: notchStartY),
                    control: CGPoint(x: rect.minX, y: notchStartY)
                )

                // Parte superior de la muesca
                path.addLine(to: CGPoint(x: rect.minX + notchSize - cornerRadius, y: notchStartY))

                // Esquina superior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + notchSize, y: notchStartY + cornerRadius),
                    control: CGPoint(x: rect.minX + notchSize, y: notchStartY)
                )

                // Lado derecho de la muesca
                path.addLine(to: CGPoint(x: rect.minX + notchSize, y: notchEndY - cornerRadius))

                // Esquina inferior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX + notchSize - cornerRadius, y: notchEndY),
                    control: CGPoint(x: rect.minX + notchSize, y: notchEndY)
                )

                // Parte inferior de la muesca
                path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: notchEndY))

                // Esquina inferior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX, y: notchEndY + cornerRadius),
                    control: CGPoint(x: rect.minX, y: notchEndY)
                )

                // Lado izquierdo después de la muesca
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

                // Completar el resto del rectángulo
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Parte inferior
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // Parte derecha
                path.closeSubpath() // Cerrar la forma
            } else {
                // Muesca en el lado derecho
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: notchStartY - cornerRadius))

                // Esquina superior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.maxX - cornerRadius, y: notchStartY),
                    control: CGPoint(x: rect.maxX, y: notchStartY)
                )

                // Parte superior de la muesca
                path.addLine(to: CGPoint(x: rect.maxX - notchSize + cornerRadius, y: notchStartY))

                // Esquina superior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.maxX - notchSize, y: notchStartY + cornerRadius),
                    control: CGPoint(x: rect.maxX - notchSize, y: notchStartY)
                )

                // Lado izquierdo de la muesca
                path.addLine(to: CGPoint(x: rect.maxX - notchSize, y: notchEndY - cornerRadius))

                // Esquina inferior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.maxX - notchSize + cornerRadius, y: notchEndY),
                    control: CGPoint(x: rect.maxX - notchSize, y: notchEndY)
                )

                // Parte inferior de la muesca
                path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: notchEndY))

                // Esquina inferior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: rect.maxX, y: notchEndY + cornerRadius),
                    control: CGPoint(x: rect.maxX, y: notchEndY)
                )

                // Lado derecho después de la muesca
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

                // Completar el resto del rectángulo
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Parte inferior
                path.closeSubpath() // Cerrar la forma
            }

        case .top, .bottom:
            // Aseguramos que la posición de la muesca esté dentro de los límites horizontales
            let notchX = max(rect.minX + notchLength / 2, min(notchPosition, rect.maxX - notchLength / 2))
            let notchStartX = notchX - notchLength / 2
            let notchEndX = notchX + notchLength / 2

            if side == .top {
                // Muesca en la parte superior
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: notchStartX - cornerRadius, y: rect.minY))

                // Esquina superior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchStartX, y: rect.minY + cornerRadius),
                    control: CGPoint(x: notchStartX, y: rect.minY)
                )

                // Lado izquierdo de la muesca
                path.addLine(to: CGPoint(x: notchStartX, y: rect.minY + notchSize - cornerRadius))

                // Esquina inferior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchStartX + cornerRadius, y: rect.minY + notchSize),
                    control: CGPoint(x: notchStartX, y: rect.minY + notchSize)
                )

                // Parte inferior de la muesca
                path.addLine(to: CGPoint(x: notchEndX - cornerRadius, y: rect.minY + notchSize))

                // Esquina inferior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchEndX, y: rect.minY + notchSize - cornerRadius),
                    control: CGPoint(x: notchEndX, y: rect.minY + notchSize)
                )

                // Lado derecho de la muesca
                path.addLine(to: CGPoint(x: notchEndX, y: rect.minY + cornerRadius))

                // Esquina superior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchEndX + cornerRadius, y: rect.minY),
                    control: CGPoint(x: notchEndX, y: rect.minY)
                )

                // Lado superior después de la muesca
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

                // Completar el resto del rectángulo
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Lado derecho
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Parte inferior
                path.closeSubpath() // Cerrar la forma
            } else {
                // Muesca en la parte inferior
                path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: notchStartX - cornerRadius, y: rect.maxY))

                // Esquina inferior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchStartX, y: rect.maxY - cornerRadius),
                    control: CGPoint(x: notchStartX, y: rect.maxY)
                )

                // Lado izquierdo de la muesca
                path.addLine(to: CGPoint(x: notchStartX, y: rect.maxY - notchSize + cornerRadius))

                // Esquina superior izquierda de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchStartX + cornerRadius, y: rect.maxY - notchSize),
                    control: CGPoint(x: notchStartX, y: rect.maxY - notchSize)
                )

                // Parte superior de la muesca
                path.addLine(to: CGPoint(x: notchEndX - cornerRadius, y: rect.maxY - notchSize))

                // Esquina superior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchEndX, y: rect.maxY - notchSize + cornerRadius),
                    control: CGPoint(x: notchEndX, y: rect.maxY - notchSize)
                )

                // Lado derecho de la muesca
                path.addLine(to: CGPoint(x: notchEndX, y: rect.maxY - cornerRadius))

                // Esquina inferior derecha de la muesca
                path.addQuadCurve(
                    to: CGPoint(x: notchEndX + cornerRadius, y: rect.maxY),
                    control: CGPoint(x: notchEndX, y: rect.maxY)
                )

                // Lado inferior después de la muesca
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

                // Completar el resto del rectángulo
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // Lado derecho
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // Parte superior
                path.closeSubpath() // Cerrar la forma
            }
        }

        return path
    }
}

struct NotchedView: View {
    @State private var isPressed = false
    @State private var deformationAmount: CGFloat = 0.0
    @State private var dampingFraction: CGFloat = 0.8
    @State private var notchPosition: CGFloat = 0.0
    @State private var notchSide: NotchPosition = .left

    var allowedSides: NotchSides = .all
    var notchFollowsTouch: Bool = true // Nuevo parámetro

    var body: some View {
        GeometryReader { geometry in
            NotchedShape(deformation: deformationAmount, notchPosition: notchPosition, side: notchSide)
                .fill(Color.blue)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .animation(.spring(response: 0.3, dampingFraction: dampingFraction), value: deformationAmount)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            isPressed = true
                            dampingFraction = 0.1
                            deformationAmount = 20 // Profundidad de la muesca

                            // Determinar el lado según la posición del toque
                            let midX = geometry.size.width / 2
                            let midY = geometry.size.height / 2

                            var detectedSide: NotchPosition?

                            if gesture.location.y < midY && gesture.location.x > gesture.location.y && gesture.location.x < geometry.size.width - gesture.location.y {
                                if allowedSides.contains(.top) {
                                    detectedSide = .top
                                    notchSide = .top
                                    notchPosition = notchFollowsTouch ? gesture.location.x : geometry.size.width / 2
                                }
                            } else if gesture.location.y > midY && gesture.location.x > geometry.size.height - gesture.location.y && gesture.location.x < geometry.size.width - (geometry.size.height - gesture.location.y) {
                                if allowedSides.contains(.bottom) {
                                    detectedSide = .bottom
                                    notchSide = .bottom
                                    notchPosition = notchFollowsTouch ? gesture.location.x : geometry.size.width / 2
                                }
                            } else if gesture.location.x < midX {
                                if allowedSides.contains(.left) {
                                    detectedSide = .left
                                    notchSide = .left
                                    notchPosition = notchFollowsTouch ? gesture.location.y : geometry.size.height / 2
                                }
                            } else {
                                if allowedSides.contains(.right) {
                                    detectedSide = .right
                                    notchSide = .right
                                    notchPosition = notchFollowsTouch ? gesture.location.y : geometry.size.height / 2
                                }
                            }

                            if detectedSide == nil {
                                // Si el lado detectado no está permitido, no mostramos la muesca
                                deformationAmount = 0
                            }
                        }
                        .onEnded { _ in
                            isPressed = false
                            dampingFraction = 0.8
                            deformationAmount = 0 // Volver a la forma original
                        }
                )
                .drawingGroup()
                .shadow(
                    color: .black.opacity(0.8),
                    radius: 10
                )
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    // Ejemplo: Muesca fija en el centro del lado permitido
    NotchedView(allowedSides: [.all], notchFollowsTouch: true)
}
