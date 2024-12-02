//
//  SwiftUIView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//

import SwiftUI

struct MiddleDragNotch: View {
    @Binding var vm: SharedScreenViewModel
    let parentGeometry: GeometryProxy
    
    var body: some View {
//        GeometryReader { geometry in
            VariableOrientationStack(orientation: vm.variableOrientation) {
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
                                                   vm.firstViewSizes.height + gesture.translation.height < parentGeometry.size.height - vm.minSize - 15 {
                                                    vm.translation.height += gesture.translation.height
                                                }
                                                vm.translation.width += gesture.translation.width
                                                break
                                            case .horizontal:
                                                if vm.firstViewSizes.width + gesture.translation.width > vm.minSize - 15,
                                                   vm.firstViewSizes.width + gesture.translation.width < parentGeometry.size.width - vm.minSize - 15 {
                                                    vm.translation.width += gesture.translation.width
                                                }
                                                vm.translation.height += gesture.translation.height
                                        }
                                    case (.vertical, .horizontal):
                                        if vm.firstViewSizes.width + gesture.translation.width > vm.minSize - 15,
                                           vm.firstViewSizes.width + gesture.translation.width < parentGeometry.size.width - vm.minSize - 15 {
                                            vm.translation.width += gesture.translation.width
                                        }
                                        vm.translation.height += gesture.translation.height
                                    case (.horizontal, .vertical):
                                        if vm.firstViewSizes.width + gesture.translation.width > vm.minSize - 15,
                                           vm.firstViewSizes.width + gesture.translation.width < parentGeometry.size.width - vm.minSize - 15 {
                                            vm.translation.width += gesture.translation.width
                                        }
                                        vm.translation.height += gesture.translation.height
                                }
                                
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
                                                        vm.translation.height = -parentGeometry.size.height/2 + minSize
                                                        
                                                    } else if vm.firstViewSizes.height >= parentGeometry.size.height - snapThreshold {
                                                        vm.translation.height =  parentGeometry.size.height/2 - minSize
                                                    }
                                                case .horizontal:
                                                    if vm.firstViewSizes.width + gesture.translation.width < snapThreshold {
                                                        vm.translation.width = -parentGeometry.size.width/2 + minSize
                                                        
                                                    } else if vm.firstViewSizes.width >= parentGeometry.size.width - snapThreshold {
                                                        vm.translation.width =  parentGeometry.size.width/2 - minSize
                                                    }
                                            }
                                        case (.vertical, .horizontal):
                                            if vm.firstViewSizes.height + gesture.translation.height < snapThreshold {
                                                vm.translation.height = -parentGeometry.size.height/2 + minSize
                                                
                                            } else if vm.firstViewSizes.height >= parentGeometry.size.height - snapThreshold {
                                                vm.translation.height =  parentGeometry.size.height/2 - minSize
                                            }
                                        case (.horizontal, .vertical):
                                            if vm.firstViewSizes.width + gesture.translation.width < snapThreshold {
                                                vm.translation.width = -parentGeometry.size.width/2 + minSize
                                                
                                            } else if vm.firstViewSizes.width >= parentGeometry.size.width - snapThreshold {
                                                vm.translation.width =  parentGeometry.size.width/2 - minSize
                                            }
                                    }
                                    
                                }
                            }
                    )
                Spacer()
            }
//        }
    }
    
    private var dragIndicatorSize: CGSize {
        switch (vm.orientation, vm.deviceOrientation) {
            case (.horizontal, .horizontal), (.horizontal, .vertical), (nil, .horizontal):
                CGSize(width: 10, height: 50)
            case (.vertical, .vertical), (.vertical, .horizontal), (nil, .vertical):
                CGSize(width: 50, height: 10)
        }
    }
}
