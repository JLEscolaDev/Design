//
//  MultiplatformImage.swift
//  Design
//
//  Created by Jose Luis Escolá García on 18/2/25.
//

import SwiftUI

#if os(macOS)
import AppKit
public typealias DesignMultiplatformImage = NSImage
#else
import UIKit
public typealias DesignMultiplatformImage = UIImage
#endif

extension DesignMultiplatformImage {
    public var toUIImage: Image {
        #if os(macOS)
            Image(nsImage: self)
        #else
            Image(uiImage: self)
        #endif
    }
}
