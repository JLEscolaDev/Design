//
//  SplitViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//

import SwiftUI

@Observable
public class SplitViewModel<TopContent: View, BottomContent: View> {
    var multiViewVM: SharedScreenViewModel
    
    /// - Parameter orientation: Set this parameter if you want to force an orentation instead of using the device automatic orientation
    public init(orientation: Orientation? = nil, topContent: TopContent, bottomContent: BottomContent, minSize: CGFloat = 100) {
        self.multiViewVM = .init(orientation: orientation, minSize: minSize)
        self.topContent = topContent
        self.bottomContent = bottomContent
    }
    
    let topContent: TopContent
    let bottomContent: BottomContent
}

// - MARK: SplitView first view and second view size calculations based on orientation and drag
extension SplitViewModel {
    func calculateViewSizes(for geometry: GeometryProxy) {
        firstSizes(for: geometry)
        secondSizes(for: geometry)
    }
    
    private func firstSizes(for geometry: GeometryProxy) {
        var finalWidth = CGFloat.zero
        var finalHeight = CGFloat.zero
        
        switch (multiViewVM.orientation, multiViewVM.deviceOrientation) {
            case (nil, _), (.vertical, .vertical), (.horizontal, .horizontal):
                
                switch multiViewVM.deviceOrientation {
                    case .vertical:
                        let width = geometry.size.width
                        let height = geometry.size.height/2 - 15
                        multiViewVM.firstViewSizes = (width, height+multiViewVM.translation.height)
                    case .horizontal:
                        let width = geometry.size.width/2 - 15
                        let height = geometry.size.height
                        multiViewVM.firstViewSizes = (width+multiViewVM.translation.width, height)
                }
            case (.vertical, .horizontal):
                let width = geometry.size.width
                let height = geometry.size.height/2 - 15+multiViewVM.translation.height
                multiViewVM.firstViewSizes = (width, height)
            case (.horizontal, .vertical):
                let width = geometry.size.width/2 + multiViewVM.translation.width
                let height = geometry.size.height
                multiViewVM.firstViewSizes = (width, height)
        }
    }
    
    private func secondSizes(for geometry: GeometryProxy) {
        let firstWidth = multiViewVM.firstViewSizes.width
        let firstHeight = multiViewVM.firstViewSizes.height
        
        return switch (multiViewVM.orientation, multiViewVM.deviceOrientation) {
            case (.vertical, .horizontal), (.vertical, .vertical), (nil, .vertical) :
                multiViewVM.secondViewSizes = (firstWidth, geometry.size.height - firstHeight - 15)
            case (.horizontal, _), (nil, .horizontal):
                multiViewVM.secondViewSizes = (geometry.size.width - firstWidth - 15, firstHeight)
        }
    }
}


