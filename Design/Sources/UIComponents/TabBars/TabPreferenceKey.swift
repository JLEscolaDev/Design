//
//  TabPreferenceKey.swift
//  Design
//
//  Created by Jose Luis Escolá García on 3/11/24.
//

import SwiftUI

// 1. Defining the PreferenceKey to collect the frames of the tabs in the tab bar
struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGRect] = [:]

    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        // Merging frames from each tab into a dictionary by their titles
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
