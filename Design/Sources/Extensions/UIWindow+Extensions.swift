//
//  Utils.swift
//
//  Created by Jose Luis Escolá García on 31/7/24.
//

#if os(macOS)
import AppKit

public extension NSWindow {
    static var current: NSWindow? {
        NSApp.mainWindow
    }
}

#else
import UIKit

public extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

#endif
