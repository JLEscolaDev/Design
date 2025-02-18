//
//  MultiplatformImage.swift
//  Design
//
//  Created by Jose Luis Escolá García on 18/2/25.
//

import SwiftUI

#if os(macOS)
import AppKit
public typealias MultiplatformImage = NSImage
#else
import UIKit
public typealias MultiplatformImage = UIImage
#endif

extension MultiplatformImage {
    public var toImage: Image {
        #if os(macOS)
            Image(nsImage: self)
        #else
            Image(uiImage: self)
        #endif
    }
}
