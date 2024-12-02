//
//  DeviceRotationViewModifier.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//


import SwiftUI

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
