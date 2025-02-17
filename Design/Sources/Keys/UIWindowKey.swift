//
//  UIWindowKey.swift
//  Design
//
//  Created by Jose Luis Escolá García on 12/11/24.
//


import SwiftUI

struct UIWindowKey: EnvironmentKey {
    static var defaultValue: UIWindow? = nil
    typealias Value = UIWindow?
}