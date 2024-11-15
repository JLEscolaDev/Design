//
//  ScrollableTabBarViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 3/11/24.
//

import SwiftUI

@Observable
class ScrollableTabBarViewModel {
    var selectedTab: String
    var tabFrames: [String: CGRect] = [:]
    var previousSelectedIndex: Int = 0
    var direction: Int = 0 // -1 for left, +1 for right
    var selectionIndicatorX: CGFloat = 0
    var selectionIndicatorWidth: CGFloat = 0
    
    let tabs: [String]
    
    init(selectedTab: String, tabs: [String]) {
        self.selectedTab = selectedTab
        self.tabs = tabs
    }
    
    func selectTab(at index: Int) {
        let tab = tabs[index]
        guard selectedTab != tab else { return }

        let newIndex = index
        let oldIndex = previousSelectedIndex
        direction = newIndex < oldIndex ? -1 : 1
        previousSelectedIndex = newIndex

        // Phase 1: Retraction backward with offset and reduced width to simulate impulse.
        withAnimation(.easeInOut(duration: 0.2)) {
            selectionIndicatorWidth = 3 // Small size for impulse effect
            selectionIndicatorX += CGFloat(direction) * -30 // Backward movement
        }

        // Phase 2: Expansion to new position with smoother animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if let frame = self.tabFrames[tab] {
                withAnimation(.easeInOut(duration: 0.4)) {
                    self.direction = 0
                    self.selectionIndicatorX = frame.minX
                    self.selectionIndicatorWidth = frame.width
                }
                self.selectedTab = tab
            }
        }
    }
}
