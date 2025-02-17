//
//  ScrollableTabBarView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/11/24.
//
import SwiftUI

// 4. Implementing ScrollableTabBarView
private struct ScrollableTabBarView: View {
    @State private var selectedTab: String = "Home"
    let tabs = ["Home", "Explore", "Favorites", "Profile", "Settings", "Messages", "Notifications"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollableTabBar(tabs: tabs, selectedTab: $selectedTab)
            
            Spacer()
            Text("Selected Tab: \(selectedTab)")
                .font(.subheadline)
                .fontWeight(.black)
                .foregroundColor(.black)
            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


extension ScrollableTabBar {
    public static var preview: some View {
        ScrollableTabBarView()
    }
}

// 5. Preview
#Preview {
    ScrollableTabBar.preview
}
