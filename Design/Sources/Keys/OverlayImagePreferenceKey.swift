//
//  OverlayImagePreferenceKey.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//
import SwiftUI

struct OverlayImagePreferenceKey: PreferenceKey {
    typealias Value = CGRect?
    static var defaultValue: CGRect? = nil

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue() ?? value
    }
}
