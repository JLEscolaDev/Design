import SwiftUI

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

