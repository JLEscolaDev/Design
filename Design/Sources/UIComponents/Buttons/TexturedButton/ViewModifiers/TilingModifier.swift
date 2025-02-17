//
//  TilingModifier.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//

import SwiftUI

struct TilingModifier: ViewModifier {
    var image: Image
    var capInsets: EdgeInsets
    var imageOpacity: Double = 1

    @State private var imageSize: CGSize?
    @State private var viewSize: CGSize?

    /// Modifies the provided content view to include a tiled background image with
    /// customizable insets and opacity.
    func body(content: Content) -> some View {
        
        // Adjust view size based on the tiled background dimensions and cap insets.
        content.frame(
            minWidth: sizeComponent(\.width,
                insetBy: (capInsets.leading, capInsets.trailing)
            ),
            minHeight: sizeComponent(\.height,
                insetBy: (capInsets.top, capInsets.bottom)
            )
        )
        // Render the tiled background image with specified opacity.
        .background(image.resizable(
            capInsets: capInsets,
            resizingMode: .tile
        ).opacity(imageOpacity))
        // Sync view's size and image size using a hidden image view.
        .syncingSize(to: $viewSize)
        .background(image.hidden().syncingSize(to: $imageSize))
    }
}

private extension TilingModifier {
    /// Calculates the length of a specified component (width or height) for tiling,
    /// adjusted by insets, based on view and image sizes.
    ///
    /// - Parameters:
    ///   - component: A KeyPath to specify the component (.width or .height) of CGSize.
    ///   - insets: A tuple representing the starting and ending insets.
    /// - Returns: The final calculated length of the component after tiling and
    ///   adjustments with insets, or `nil` if view and image sizes are not set.
    func sizeComponent(
        _ component: KeyPath<CGSize, CGFloat>,
        insetBy insets: (CGFloat, CGFloat)
    ) -> CGFloat? {
        // If viewSize or imageSize is not yet captured, return nil until available.
        guard let viewSize = viewSize,
              let imageSize = imageSize else {
            return nil
        }

        // Compute the tiling length by removing insets from the component's total length.
        let tiling: (CGFloat) -> CGFloat = {
            $0 - insets.0 - insets.1
        }
        
        let viewMetric = tiling(viewSize[keyPath: component])
        let imageMetric = tiling(imageSize[keyPath: component])
        
        // Calculate the total length to fit tiled images and insets.
        let tileCount = ceil(viewMetric / imageMetric)
        return insets.0 + tileCount * imageMetric + insets.1
    }
}
