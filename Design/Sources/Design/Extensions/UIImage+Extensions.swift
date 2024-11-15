//
//  File.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//
import UIKit

extension UIImage {
    func getPixelColor(at point: CGPoint) -> UIColor? {
        guard let cgImage = cgImage,
              let dataProvider = cgImage.dataProvider,
              let data = dataProvider.data,
              let bytes = CFDataGetBytePtr(data) else { return nil }
        
        let bytesPerPixel = 4
        let bytesPerRow = cgImage.bytesPerRow
        let byteIndex = Int(point.y) * bytesPerRow + Int(point.x) * bytesPerPixel
        
        let r = CGFloat(bytes[byteIndex]) / 255.0
        let g = CGFloat(bytes[byteIndex + 1]) / 255.0
        let b = CGFloat(bytes[byteIndex + 2]) / 255.0
        let a = CGFloat(bytes[byteIndex + 3]) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
