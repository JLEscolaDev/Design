//
//  SharedScreenViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//


import SwiftUI

@Observable
public class SharedScreenViewModel {
    var deviceOrientation: Orientation
    
    /// - Parameter orientation: Set this parameter if you want to force an orentation instead of using the device automatic orientation
    public init(orientation: Orientation? = nil, minSize: CGFloat = 100) {
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
    
    @ObservationIgnored var firstViewSizes: (width: CGFloat, height: CGFloat) = (0, 0)
    @ObservationIgnored var secondViewSizes: (width: CGFloat, height: CGFloat) = (0, 0)
    
    var variableOrientation: Orientation {
        switch (orientation, deviceOrientation) {
            case (.vertical, .vertical), (.vertical, .horizontal), (nil, .vertical):
                    .vertical
            case (.horizontal, .vertical), (.vertical, .vertical), (.horizontal, .horizontal), (nil, .horizontal):
                    .horizontal
        }
    }
}
