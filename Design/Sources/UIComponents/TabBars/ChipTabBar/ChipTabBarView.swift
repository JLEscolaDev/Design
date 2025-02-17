//
//  ChipTabBarView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

struct ChipTabBarView: View {
    @Binding var selectedTab: Int
    var viewModels: [TabBarButtonViewModel]
    
    var body: some View {
        HStack {
            ForEach(0..<viewModels.count, id: \.self) { index in
                TabBarButton(vm: viewModels[index])
                    .onTapGesture {
                        selectedTab = index
                        updateSelection(for: index)
                    }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background {
            Rectangle().blur(radius: 0)
        }
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
    
    private func updateSelection(for index: Int) {
        for (i, vm) in viewModels.enumerated() {
            vm.isSelected = (i == index)
        }
    }
}

@_spi(Demo) public struct ChipTabBarPreview: View {
    public init(selectedTab: Int = 0) {
        self.selectedTab = selectedTab
    }
    
    @State private var selectedTab: Int = 0
    
    private var viewModels: [TabBarButtonViewModel] {
        [
            TabBarButtonViewModel(icon: "house.fill", title: "Inicio", isSelected: selectedTab == 0) {
                selectedTab = 0
            },
            TabBarButtonViewModel(icon: "magnifyingglass", title: "Buscar", isSelected: selectedTab == 1) {
                selectedTab = 1
            },
            TabBarButtonViewModel(icon: "bell.fill", title: "Notificaciones", isSelected: selectedTab == 2) {
                selectedTab = 2
            },
            TabBarButtonViewModel(icon: "gearshape.fill", title: "Ajustes", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        ]
    }
    
    public var body: some View {
        ChipTabBarView(selectedTab: $selectedTab, viewModels: viewModels)
    }
}

#Preview {
    ChipTabBarPreview()
}
