//
//  BouncyTabBarButton.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 5/6/24.
//

import SwiftUI

/// A view representing a single button in the BouncyTabBar.
struct BouncyTabBarButton: View {
    init(_ vm: BouncyTabBarViewModel) {
        self.vm = vm
    }
    
    /// View model containing the state and behavior for the tab bar.
    @State var vm: BouncyTabBarViewModel
    
    /// Enum defining various animation durations.
    private enum AnimationTimes {
        static let tabTransition = 0.3
        static let toggleTabCurveVisibility = 0.2
        static let selectorCircleResponse = 0.7
        static let selectorCircleDampingFraction = 0.75
        static let bounceResponse = 0.5
        static let bounceDampingFraction = 0.3
    }
    
    /// The currently selected tab for animations.
    @State private var selectedTabForAnimations = 0
    
    /// The x-axis position for the tab button.
    @State private var xAxis: CGFloat = 0
    
    /// The curve amount for the animation.
    @State private var curveAmount: CGFloat = 1.0
    
    /// Indicates if the center tab is selected.
    @State private var isCenterTab: Bool = false
    
    /// A task to handle the animation.
    @State private var animationTask: Task<Void, Never>? = nil
    
    /// Indicates if the center button is currently jumping.
    @State private var isCenterButtonJumping = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(vm.tabs.compactMap({$0.tabButton}).enumerated()), id: \.offset) { index, tabButton in
                GeometryReader { reader in
                    Button(action: {
                        handleTabSelection(tabButton: tabButton, index: index, reader: reader)
                    }, label: {
                        Image(uiImage: tabButton.image ?? UIImage())
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(selectedTabForAnimations == index ? .blue : .gray)
                            .scaleEffect(
                                selectedTabForAnimations == index &&
                                isCenterTab &&
                                (vm.centerTabIndex != nil ? index == vm.tabs[vm.centerTabIndex ?? 0].tabButton.tag : false) ? 2.3 : 1, anchor: .center)
                            .symbolVariant(selectedTabForAnimations == index ? .fill : .none)
                            .offset(x: 6, y: vm.selectedTab == index && isCenterTab ? (isCenterButtonJumping ? vm.circleYOffset : vm.circleYOffset - 17) : 0)
                    })
                    .onAppear {
                        if index == vm.tabs.first?.tabButton.tag {
                            xAxis = reader.frame(in: .global).minX
                            vm.selectorCircleXAxis = xAxis
                        }
                    }
                }
                .frame(width: 25.0, height: 60.0)
                if index != vm.tabs.last?.tabButton.tag { Spacer() }
            }
        }
        .padding(.horizontal, 50)
        .padding(.vertical)
        .background(
            Color.white
                .clipShape(BouncyTabBarShapeWithSelectorCurve(xAxis: xAxis, curveAmount: curveAmount))
                .animation(.spring(response: AnimationTimes.bounceResponse, dampingFraction: AnimationTimes.bounceDampingFraction), value: curveAmount)
        )
    }
    
    /// Handles the selection of a tab.
    ///
    /// - Parameters:
    ///   - tabButton: The selected tab button.
    ///   - index: The index of the selected tab.
    ///   - reader: The geometry reader for the tab button.
    @MainActor
    private func handleTabSelection(tabButton: UITabBarItem, index: Int, reader: GeometryProxy) {
        animationTask?.cancel()
        animationTask = Task {
            withAnimation(.smooth(duration: AnimationTimes.tabTransition)) {
                vm.selectedTab = tabButton.tag
                xAxis = reader.frame(in: .global).minX
                isCenterTab = index == vm.centerTabIndex
                vm.circleYOffset = 0
                vm.circleSize = 35
            }
            withAnimation(.spring(response: AnimationTimes.selectorCircleResponse, dampingFraction: AnimationTimes.selectorCircleDampingFraction, blendDuration: 0)) {
                vm.selectorCircleXAxis = xAxis
            }
            if isCenterTab,
               let centerTabIndex = vm.centerTabIndex {
                try? await Task.sleep(nanoseconds: UInt64(AnimationTimes.tabTransition * 1_000_000_000))
                guard !Task.isCancelled else { return }
                withAnimation(.spring(response: AnimationTimes.bounceResponse, dampingFraction: AnimationTimes.bounceDampingFraction, blendDuration: 0)) {
                    isCenterButtonJumping = true
                    curveAmount = vm.selectedTab == vm.tabs[centerTabIndex].tabButton.tag ? 0 : 1
                    vm.circleYOffset = -90
                }
                try? await Task.sleep(nanoseconds: 400_000_000)
                guard !Task.isCancelled else { return }
                withAnimation(.spring(response: AnimationTimes.bounceResponse, dampingFraction: AnimationTimes.bounceDampingFraction)) {
                    vm.circleSize = 70
                    vm.circleYOffset = -20
                }
                try? await Task.sleep(nanoseconds: 1_000_000)
                guard !Task.isCancelled else { return }
                withAnimation(.smooth(duration: 0.3)) {
                    selectedTabForAnimations = tabButton.tag
                }
                withAnimation(.bouncy(duration: 0.5, extraBounce: 0.4)) {
                    isCenterButtonJumping = false
                }
            } else {
                selectedTabForAnimations = tabButton.tag
                withAnimation(.easeInOut(duration: AnimationTimes.toggleTabCurveVisibility)) {
                    curveAmount = 1
                    vm.circleYOffset = 0
                    vm.circleSize = 35
                    isCenterButtonJumping = false
                }
                try? await Task.sleep(nanoseconds: 1_000_000)
                guard !Task.isCancelled else { return }
            }
        }
    }
}
