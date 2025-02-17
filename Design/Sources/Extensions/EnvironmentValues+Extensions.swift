//
//  EnvironmentValues+Extensions.swift
//  Design
//
//  Created by Jose Luis Escolá García on 12/11/24.
//
import SwiftUI

extension EnvironmentValues {
    var window: UIWindow? {
        get { self[UIWindowKey.self] }
        set { self[UIWindowKey.self] = newValue }
    }
}
