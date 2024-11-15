//
//  TabBarItem.swift
//  Design
//
//  Created by Jose Luis Escolá García on 3/11/24.
//

import SwiftUI

// 2. Implementing TabBarItem using a named coordinate space for consistent frame measurements
struct TabBarItem: View {
    let title: String
    let isSelected: Bool
    var animation: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text(title)
                    .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                // Using GeometryReader to capture each tab's frame in the "tabBar" coordinate space
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: TabPreferenceKey.self, value: [title: geometry.frame(in: .named("tabBar"))])
                }
            )
        }
    }
}
