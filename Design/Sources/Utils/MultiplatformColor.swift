//
//  MultiplatformColor.swift
//  Design
//
//  Created by Jose Luis Escolá García on 19/2/25.
//

import SwiftUI

#if os(macOS)
import AppKit
public typealias MultiplatformColor = NSColor
#else
import UIKit
public typealias MultiplatformColor = UIColor
#endif

extension MultiplatformColor {
    var toSwiftUIColor: Color {
        #if os(macOS)
        return Color(self)
        #else
        return Color(self)
        #endif
    }
}

extension MultiplatformColor {
    static func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> MultiplatformColor {
            #if os(macOS)
            return NSColor(red: red, green: green, blue: blue, alpha: alpha)
            #else
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            #endif
        }
}
