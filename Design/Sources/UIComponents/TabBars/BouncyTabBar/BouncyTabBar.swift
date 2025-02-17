import SwiftUI

/// A view representing the BouncyTabBar, a custom tab bar with animated selection effects.
public struct BouncyTabBar: View {
    /// Initializes a new BouncyTabBar with the provided tab items.
    /// - Parameter tabs: A variadic list of `BouncyTabBarItem` elements.
    public init(_ tabs: BouncyTabBarItem...) {
        vm = BouncyTabBarViewModel(tabs)
        UITabBar.appearance().isHidden = true
    }
    
    /// The view model managing the state and behavior of the tab bar.
    @State private var vm: BouncyTabBarViewModel
    
    public var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            viewsPerTab
            selectionCircle
            BouncyTabBarButton(vm)
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

// MARK: Subviews
extension BouncyTabBar {
    private var viewsPerTab: some View {
        TabView(selection: $vm.selectedTab) {
            ForEach(0..<vm.tabs.count, id: \.self) { index in
                HStack {
                    vm.tabs[index].view
                        .tag(index)
                    .ignoresSafeArea(.all, edges: .bottom)
                }
            }
        }
    }
    
    private var selectionCircle: some View {
        Circle()
            .fill(Color.white)
            .frame(width: vm.circleSize, height: vm.circleSize)
            .offset(x: (vm.selectorCircleXAxis + 16) - UIScreen.main.bounds.width / 2, y: -48 + vm.circleYOffset)
    }
}

// MARK: Preview
extension BouncyTabBar {
    public static var preview: some View {
        BouncyTabBar(
            BouncyTabBarItem(tabButton: .init(title: "Mapa", image: UIImage(systemName: "mappin.circle"), tag: 0))
            { Color.red },
            
            BouncyTabBarItem(tabButton: .init(title: "Actualidad", image: UIImage(systemName: "newspaper"), tag: 1))
            { Color.blue },
            
            BouncyTabBarItem(tabButton: .init(title: "", image: UIImage(systemName: "plus.circle"), tag: 2))
            { Color.orange },
            
            BouncyTabBarItem(tabButton: .init(title: "Consumo", image: UIImage(systemName: "wineglass"), tag: 3))
            { Color.brown },
            
            BouncyTabBarItem(tabButton: .init(title: "Consumo", image: UIImage(systemName: "gamecontroller"), tag: 4))
            { Color.yellow }
        )
    }
}

#Preview {
    BouncyTabBar.preview
}



