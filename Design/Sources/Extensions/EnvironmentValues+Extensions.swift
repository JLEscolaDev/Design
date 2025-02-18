//
//  EnvironmentValues+Extensions.swift
//  Design
//
//  Created by Jose Luis Escolá García on 12/11/24.
//
import SwiftUI

#if os(macOS)
import AppKit

private struct NSWindowKey: EnvironmentKey {
    static let defaultValue: NSWindow? = nil
}

extension EnvironmentValues {
    var window: NSWindow? {
        get { self[NSWindowKey.self] }
        set { self[NSWindowKey.self] = newValue }
    }
}
#else
import UIKit

extension EnvironmentValues {
    var window: UIWindow? {
        get { self[UIWindowKey.self] }
        set { self[UIWindowKey.self] = newValue }
    }
}
#endif
