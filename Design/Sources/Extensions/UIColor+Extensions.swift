//
//  File.swift
//  
//
//  Created by Jose Luis Escolá on 31/5/23.
//

import SwiftUI

public extension MultiplatformColor {
    /// Initialize a color using a hex string, e.g. `#FF0000`
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        guard cString.count == 6 else {
            self.init(red: 1, green: 1, blue: 1, alpha: alpha)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat(rgbValue & 0x0000FF)         / 255.0,
            alpha: alpha
        )
    }
    
    /// Convert the color to a hex string (e.g. `#FF0000`)
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}

// MARK: - MultiplatformColor (UIColor / NSColor) Extensions

public extension MultiplatformColor {
    /// Darken the color by a percentage.
    func darker(by percentage: CGFloat = 0.3) -> MultiplatformColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        #if os(macOS)
        self.usingColorSpace(.deviceRGB)?.getRed(&r, green: &g, blue: &b, alpha: &a)
        #else
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        
        return MultiplatformColor(
            red:   max(r - percentage, 0.0),
            green: max(g - percentage, 0.0),
            blue:  max(b - percentage, 0.0),
            alpha: a
        )
    }
    
    /// Lighten the color by a percentage.
    func lighter(by percentage: CGFloat = 0.3) -> MultiplatformColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        #if os(macOS)
        self.usingColorSpace(.deviceRGB)?.getRed(&r, green: &g, blue: &b, alpha: &a)
        #else
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        
        return MultiplatformColor(
            red:   min(r + percentage, 1.0),
            green: min(g + percentage, 1.0),
            blue:  min(b + percentage, 1.0),
            alpha: a
        )
    }
}

// MARK: - SwiftUI.Color Extensions

public extension Color {
    /// Initialize a SwiftUI `Color` using a hex string.
    init(hex: String) {
        self.init(MultiplatformColor(hex: hex))
    }
    
    /// Darken a SwiftUI Color by a percentage.
    func darker(by percentage: CGFloat = 0.3) -> Color {
        return Color(MultiplatformColor(self).darker(by: percentage))
    }
    
    /// Lighten a SwiftUI Color by a percentage.
    func lighter(by percentage: CGFloat = 0.3) -> Color {
        return Color(MultiplatformColor(self).lighter(by: percentage))
    }
}
