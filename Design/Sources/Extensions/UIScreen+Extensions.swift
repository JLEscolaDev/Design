//
//  File.swift
//  Design
//
//  Created by Jose Luis Escolá García on 30/11/24.
//

import UIKit

public extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
