import SwiftUI

#if os(macOS)
import AppKit

struct DynamicColor {
    static var lightGray: Color {
        Color(NSColor(name: nil, dynamicProvider: { appearance in
            // appearance.name can be: .darkAqua, .aqua, or other variants
            switch appearance.name {
            case .darkAqua:
                // Dark mode
                return NSColor(white: 0.8, alpha: 1.0)
            default:
                // Light mode (or any other appearance)
                return NSColor(white: 0.9, alpha: 1.0)
            }
        }))
    }
}
#else
struct DynamicColor {
    static var lightGray: Color {
        Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(white: 0.8, alpha: 1.0) // Adjust this color for dark mode
            default:
                return UIColor(white: 0.9, alpha: 1.0) // Adjust this color for light mode
            }
        })
    }
}
#endif
