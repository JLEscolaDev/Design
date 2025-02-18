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

