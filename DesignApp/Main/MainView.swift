//
//  ContentView.swift
//  DesignApp
//
//  Created by Jose Luis Escolá García on 30/10/24.
//

import SwiftUI

struct MainView: View {
    @State private var vm = MainViewModel()
    
    init() {
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo de gradiente en toda la vista
                LinearGradient(
                    gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(vm.items) { item in
                            NavigationLink(destination: item.destinationView) {
                                HStack {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .background(Color.clear)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle("Components")
            }
        }
    }
}

#Preview {
    MainView()
}
