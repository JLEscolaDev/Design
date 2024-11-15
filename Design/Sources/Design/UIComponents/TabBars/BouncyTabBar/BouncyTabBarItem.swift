//
//  BouncyTabBarItem.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 5/6/24.
//

import SwiftUI

/// A view representing a single tab bar item.
public struct BouncyTabBarItem: View {
    let tabButton: UITabBarItem
    let view: AnyView

    /// Initializes a new tab bar item with the provided tab button and view.
    ///
    /// - Parameters:
    ///   - tabButton: The tab button associated with this item.
    ///   - view: The view that should be displayed when the tab is selected.
    public init<Content: View>(tabButton: UITabBarItem, @ViewBuilder view: () -> Content) {
        self.tabButton = tabButton
        self.view = AnyView(view())
    }

    public var body: some View {
        view
    }
}
