//#if os(macOS)
//
//import AppKit
//
//public extension NSScreen {
//    static var current: NSScreen? {
//        NSApp.mainWindow?.screen
//    }
//}
//
//#else
//import UIKit
//
//public extension UIScreen {
//    static var current: UIScreen? {
//        UIWindow.current?.screen
//    }
//}
//#endif

#if os(macOS)
import AppKit

public struct MultiplatformScreen {
    public static var current: NSScreen? {
        NSApp.mainWindow?.screen ?? NSScreen.main
    }
    
    public static var main: NSScreen? {
        NSApp.mainWindow?.screen ?? NSScreen.main
    }
    
    public static var bounds: CGRect {
        main?.frame ?? .zero  // ✅ Usa 'frame' en lugar de 'bounds'
    }
}
#elseif os(visionOS)
import SwiftUI

public struct MultiplatformScreen {
    /// Retrieves the available space dynamically using GeometryReader
    public static var bounds: CGRect {
        SceneBounds.shared.bounds
    }
}

/// Singleton to store the app's available space dynamically
final class SceneBounds: ObservableObject {
    static let shared = SceneBounds()
    
    @Published var bounds: CGRect = .zero

    private init() {}

    /// Updates the stored bounds asynchronously
    func updateBounds(_ newBounds: CGRect) {
        DispatchQueue.main.async {
            self.bounds = newBounds
        }
    }
}

/// View to observe and capture the available scene space
struct BoundsObserver: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    SceneBounds.shared.updateBounds(CGRect(origin: .zero, size: geo.size))
                }
                .onChange(of: geo.size) { newSize in
                    SceneBounds.shared.updateBounds(CGRect(origin: .zero, size: newSize))
                }
        }
    }
}
#else
import UIKit

public struct MultiplatformScreen {
    public static var current: UIScreen? {
        UIWindow.current?.screen ?? UIScreen.main
    }
    
    public static var main: UIScreen {
        UIScreen.main
    }
    
    public static var bounds: CGRect {
        main.bounds  // ✅ UIScreen sí tiene 'bounds'
    }
}
#endif

