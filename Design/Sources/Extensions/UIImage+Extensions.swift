//
//  File.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//

import SwiftUI

extension DesignMultiplatformImage {
    /// Returns the color (NSColor or UIColor) of the pixel at a given point.
    func getPixelColor(at point: CGPoint) -> MultiplatformColor? {
        #if os(macOS)
        // Convert NSImage to CGImage
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        #else
        // On iOS, UIImage has `cgImage` directly
        guard let cgImage = self.cgImage else {
            return nil
        }
        #endif
        
        let width = cgImage.width
        let height = cgImage.height
        
        // Bounds check
        guard point.x >= 0, point.y >= 0,
              Int(point.x) < width, Int(point.y) < height else {
            return nil
        }
        
        guard let dataProvider = cgImage.dataProvider,
              let data = dataProvider.data,
              let bytes = CFDataGetBytePtr(data) else {
            return nil
        }
        
        let bytesPerPixel = 4
        let bytesPerRow = cgImage.bytesPerRow
        let byteIndex = Int(point.y) * bytesPerRow + Int(point.x) * bytesPerPixel
        
        let r = CGFloat(bytes[byteIndex])     / 255.0
        let g = CGFloat(bytes[byteIndex + 1]) / 255.0
        let b = CGFloat(bytes[byteIndex + 2]) / 255.0
        let a = CGFloat(bytes[byteIndex + 3]) / 255.0
        
        // Return the appropriate platform color
        #if os(macOS)
        return MultiplatformColor(red: r, green: g, blue: b, alpha: a)
        #else
        return MultiplatformColor(red: r, green: g, blue: b, alpha: a)
        #endif
    }
}
