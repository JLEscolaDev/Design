//
//  UIWindowKey.swift
//  Design
//
//  Created by Jose Luis Escolá García on 12/11/24.
//

#if os(macOS)
import SwiftUI

struct UIWindowKey: EnvironmentKey {
    static var defaultValue: NSWindow? = nil
    typealias Value = NSWindow?
}
#else
import SwiftUI

struct UIWindowKey: EnvironmentKey {
    static var defaultValue: UIWindow? = nil
    typealias Value = UIWindow?
}
#endif
