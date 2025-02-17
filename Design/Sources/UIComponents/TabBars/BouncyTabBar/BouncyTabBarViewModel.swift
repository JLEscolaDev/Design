//
//  BouncyTabBarViewModel.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 5/6/24.
//

import SwiftUI

/// A view model class for the BouncyTabBar, managing the state and behavior of the tab bar.
@Observable
class BouncyTabBarViewModel {
    /// An array of tab bar items.
    @ObservationIgnored var tabs: [BouncyTabBarItem]
    
    /// The total number of tabs.
    @ObservationIgnored let numberOfTabs: Int
    
    /// The index of the center tab, if applicable.
    @ObservationIgnored let centerTabIndex: Int?
    
    /// The currently selected tab index.
    var selectedTab = 0
    
    /// The x-axis position of the selector circle (used for animating the tab bar selection with a circle background shape)
    var selectorCircleXAxis: CGFloat = 0
    
    /// The y-offset of the selector circle. (mainly used in case of having even tabs to move the center tab a little bit on top to make it stand out over the other tabs)
    var circleYOffset: CGFloat = 0
    
    /// The size of the selector circle. (Used in case of having even tabs to make the center tab bigger than the other tab button, to make it stand out over the other tabs)
    var circleSize: CGFloat = 35
    
    /// Initializes a new view model with the provided tabs.
    ///
    /// - Parameter tabs: An array of `BouncyTabBarItem`.
    init(_ tabs: [BouncyTabBarItem]) {
        self.tabs = tabs
        self.numberOfTabs = tabs.count
        self.centerTabIndex = numberOfTabs % 2 == 0 ? nil : Int(Float(numberOfTabs / 2).rounded(.toNearestOrEven))
        UITabBar.appearance().isHidden = true
    }
}
