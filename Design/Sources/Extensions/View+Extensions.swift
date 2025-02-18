//
//  View+Extensions.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//
import SwiftUI

extension View {
    func syncingSize(to binding: Binding<CGSize?>) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(
                key: SizePreferenceKey.self,
                value: proxy.size
            )
        })
        .onPreferenceChange(SizePreferenceKey.self) {
            binding.wrappedValue = $0
        }
    }
    
    /// Applies a tiled background to the current view with custom image, insets, and opacity.
    ///
    /// - Parameters:
    ///   - image: The `Image` to use as the background.
    ///   - capInsets: `EdgeInsets` to define the padding for the image tiling.
    ///   - imageOpacity: `Double` value to set the opacity level of the tiled image.
    /// - Returns: A modified view with the tiled background applied.
    func tiledBackground(with image: Image,
                         capInsets: EdgeInsets,
                         withOpacity imageOpacity: Double = 1) -> some View {
        modifier(TilingModifier(
            image: image,
            capInsets: capInsets,
            imageOpacity: imageOpacity
        ))
    }

}

fileprivate struct SizePreferenceKey: PreferenceKey {
    /// Default value for preference key (initialized to zero size).
    static let defaultValue = CGSize.zero

    /// Updates the preference key value to the latest available size.
    static func reduce(value: inout CGSize,
                       nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func withNotch(
        allowedSides: NotchSides = .all,
        notchFollowsTouch: Bool = true,
        invertNotchDisplay: Bool = false,
        onNotchEnded: ((NotchPosition, CGFloat) -> Void)? = nil
    ) -> some View {
        self.modifier(
            NotchModifier(
                vm: .init(
                    allowedSides: allowedSides,
                    notchFollowsTouch: notchFollowsTouch,
                    invertNotchDisplay: invertNotchDisplay,
                    onNotchEnded: onNotchEnded
                )
            )
        )
    }
}

