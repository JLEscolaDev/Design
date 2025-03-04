//
//  DeviceRotationViewModifier.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//

import SwiftUI

#if os(iOS)
import UIKit

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Trigger once on appear, with a small delay to ensure correct orientation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    action(UIDevice.current.orientation)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    /// Used to detect device rotation changes
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
#endif
