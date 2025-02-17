//
//  ScrollableTabBar.swift
//  Design
//
//  Created by Jose Luis Escolá García on 3/11/24.
//

import SwiftUI

// 3. Implementing ScrollableTabBar with the selection indicator inside the ScrollView to synchronize scrolling
public struct ScrollableTabBar: View {
    @Binding var selectedTab: String
    @Namespace private var animation
    @State private var vm: ScrollableTabBarViewModel

    public init(tabs: [String], selectedTab: Binding<String>) {
        self._selectedTab = selectedTab
        self.vm = ScrollableTabBarViewModel(selectedTab: selectedTab.wrappedValue, tabs: tabs)
    }

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack(alignment: .bottomLeading) {
                    HStack(spacing: 20) {
                        ForEach(Array(vm.tabs.enumerated()), id: \.element) { index, tab in
                            TabBarItem(title: tab, isSelected: vm.selectedTab == tab, animation: animation) {
                                vm.selectTab(at: index)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .coordinateSpace(name: "tabBar") // Defining coordinate space for consistent measurements
                    .onPreferenceChange(TabPreferenceKey.self) { value in
                        vm.tabFrames = value
                        if let frame = vm.tabFrames[vm.selectedTab] {
                            // Adjusting the selection indicator's position based on direction
                            vm.selectionIndicatorX = vm.direction == -1 ? frame.maxX : vm.direction == 0 ? frame.midX : frame.minX
                            vm.selectionIndicatorWidth = frame.width
                        }
                    }
                    
                    // Selection indicator inside the ScrollView to stay in sync with scrolling
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(Color.blue)
                        .position(x: vm.selectionIndicatorX)
                        .frame(width: vm.selectionIndicatorWidth, height: 3)
                        .animation(.easeInOut(duration: 0.4), value: vm.selectionIndicatorX)
                }
            }
            .coordinateSpace(name: "tabBar") // Ensuring the ScrollView uses the same coordinate space
        }
        .frame(height: 60)
        .shadow(radius: 5)
        .onChange(of: vm.selectedTab) { newSelectedTab in
            selectedTab = newSelectedTab
        }
    }
}
