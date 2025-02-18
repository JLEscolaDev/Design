//
//  DeviceRotationViewModifier.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/12/24.
//

//import SwiftUI
//
//#if os(macOS)
//import AppKit
//
//// En macOS no existe la misma noción de "rotación de dispositivo".
//// Puedes dejar este ViewModifier como 'no-op' o adaptarlo a los cambios de tamaño de ventana (si fuera necesario).
//struct DeviceRotationViewModifier: ViewModifier {
//    // Aquí, sustituye UIDeviceOrientation por lo que necesites en macOS (por ejemplo, NSEvent, NSWindow, etc.)
//    // o incluso deja un tipo vacío si no deseas hacer nada.
//    let action: (String) -> Void
//    
//    func body(content: Content) -> some View {
//        // No hay rotación de dispositivo en macOS como en iOS, así que no hacemos nada
//        content
//    }
//}
//
//#else
//import UIKit
//
//// Este es el código original para iOS
//struct DeviceRotationViewModifier: ViewModifier {
//    let action: (UIDeviceOrientation) -> Void
//    
//    func body(content: Content) -> some View {
//        content
//            .onAppear {
//                // Forzar una comprobación de orientación con un pequeño retraso para asegurar el valor correcto
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    action(UIDevice.current.orientation)
//                }
//            }
//            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
//                action(UIDevice.current.orientation)
//            }
//    }
//}
//#endif
import SwiftUI

#if os(macOS)
/// macOS version: No-op or replace with window resizing logic if you want.
struct DeviceRotationViewModifierMacOS: ViewModifier {
    func body(content: Content) -> some View {
        // We do nothing on macOS, as there's no "device rotation"
        content
    }
}

extension View {
    /// Used to detect device rotation changes on iOS. On macOS, it's effectively a no-op.
    func onRotate(perform action: @escaping (String) -> Void) -> some View {
        // For macOS, we just ignore the action or call it with a dummy value if needed
        self.modifier(DeviceRotationViewModifierMacOS())
    }
}

#else
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
