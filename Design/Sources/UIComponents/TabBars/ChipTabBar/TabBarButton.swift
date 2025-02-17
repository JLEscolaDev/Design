//
//  TabBarButton.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

@Observable
public class TabBarButtonViewModel {
    public init(icon: String, title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    var icon: String
    var title: String
    var isSelected: Bool
    var action: () -> Void
}

struct TabBarButton: View {
    var vm: TabBarButtonViewModel

    var body: some View {
        Button(action: vm.action) {
            VStack(spacing: 5) {
                Image(systemName: vm.icon)
                    .font(.system(size: 22))
                    .foregroundColor(vm.isSelected ? Color(hex: "FFD700") : .gray)

                Text(vm.title)
                    .font(.caption)
                    .foregroundColor(vm.isSelected ? Color(hex: "FFD700") : .gray)
            }
            .padding(.horizontal, 10)
        }
    }
}
