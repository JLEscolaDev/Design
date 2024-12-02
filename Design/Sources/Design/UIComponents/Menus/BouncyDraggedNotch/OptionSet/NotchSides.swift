//
//  NotchSides.swift
//  Design
//
//  Created by Jose Luis Escolá García on 29/11/24.
//

import SwiftUI

// OptionSet para los lados permitidos
public struct NotchSides: OptionSet {
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public let rawValue: Int

    public static let left   = NotchSides(rawValue: 1 << 0)
    public static let right  = NotchSides(rawValue: 1 << 1)
    public static let top    = NotchSides(rawValue: 1 << 2)
    public static let bottom = NotchSides(rawValue: 1 << 3)

    public static let all: NotchSides = [.left, .right, .top, .bottom]
}
