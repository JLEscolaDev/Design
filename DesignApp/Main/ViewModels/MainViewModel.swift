//
//  MainViewModel.swift
//  DesignApp
//
//  Created by Jose Luis Escolá García on 30/10/24.
//

@_spi(Demo) import Design
import SwiftUI

@Observable
class MainViewModel {
    var items: [SectionItem] = [
        SectionItem(title: "Cards", destinationView: AnyView(cards)),
        SectionItem(title: "TextFields", destinationView: AnyView(textFields)),
        SectionItem(title: "Cells", destinationView: AnyView(CellsView())),
        SectionItem(title: "Dibujado a bajo nivel", destinationView: AnyView(customComponents)),
        SectionItem(title: "Loaders", destinationView: AnyView(loaders)),
        SectionItem(title: "Buttons", destinationView: AnyView(buttons)),
        SectionItem(title: "Backgrounds", destinationView: AnyView(backgrounds)),
        SectionItem(title: "Carousels", destinationView: AnyView(Carousles())),
        SectionItem(title: "Non interactive components", destinationView: AnyView(nonInteractiveComponents)),
        SectionItem(title: "Tab bars", destinationView: AnyView(TabBars())),
        SectionItem(title: "Effects", destinationView: AnyView(effects)),
        SectionItem(title: "Menus", destinationView: AnyView(menus))
    ]
    
    // MARK: Subviews
    static private var cards: some View {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .overlay {
                List {
                    Section {
                        EventCardView.previews
                        EventCard.preview
                    } header: {
                        Text("Events").sectionTitleStyle()
                    }
                    
                    Section {
                        InformativeCard.preview
                    } header: {
                        Text("Informative").sectionTitleStyle()
                    }
                    
                    Section {
                        SquareCard.preview
                    } header: {
                        Text("Squares").sectionTitleStyle()
                    }
                    
                    Section {
                        ScratchCard.preview
                    } header: {
                        Text("Scratch Cards").sectionTitleStyle()
                    }
                }
                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .navigationTitle("Cards")
                #if os(macOS)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Cards").font(.headline)
                    }
                }
                .listStyle(.inset)
                #else
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                #endif
            }
    }
    
//     private var cells: some View {
//        @State var selectedTab: String = "Basic"
//        return LinearGradient(
//            gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )
//        .edgesIgnoringSafeArea(.all)
//        .overlay {
//            VStack {
//                ScrollableTabBar(tabs: ["Basic", "Liquid"], selectedTab: $selectedTab)
//                
//                switch selectedTab {
//                    case "Basic":
//                        List {
//                            Text("Basic Cell").sectionTitleStyle(.dark)
//                            BasicCellWithIcon.preview
//                            
//                        }
//                    case "Liquid":
//                        LiquidViewCell.preview
//                        
//                    default:
//                        EmptyView()
//                }
//            }
//            
//            .navigationTitle("Cells")
//            .navigationBarTitleDisplayMode(.inline)
//            .scrollContentBackground(.hidden)
//        }
//    }
    
    
    static private var textFields: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay {
            List {
                Text("Simplified Text Field").sectionTitleStyle(.dark)
                SimplifiedTextFieldView.preview
                
            }
            .navigationTitle("Text Fields")
            #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Text Fields").font(.headline)
                }
            }
            .listStyle(.inset)
            #else
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            #endif
        }
    }
    
    static private var customComponents: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay {
            List {
                Text("Horizontal dashed line").sectionTitleStyle(.dark)
                DashedSeparatorLine()
            }
            .navigationTitle("Custom components")
            #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Custom components").font(.headline)
                }
            }
            .listStyle(.inset)
            #else
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            #endif
        }
    }
    
    static private var loaders: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay {
            ScrollView {
                VStack {
                    Text("Element Loading Placeholder View").sectionTitleStyle(.light)
                    ElementLoadingPlaceholderView.preview
                    
                    Text("Level Progress Ring").sectionTitleStyle(.light)
                    LevelProgressRing.preview
                    
                    Text("Custom progressbar view").sectionTitleStyle(.light)
                    CustomProgressBarView.preview
                    
                    Text("Circular progress styles").sectionTitleStyle(.light)
                    CircularProgressLoader.preview
                }
            }
            .navigationTitle("Loaders")
        }
    }
    
    static private var buttons: some View {
        let gradient = LinearGradient(colors: [.orange, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
        return TabView {
                    ZStack {
                        gradient
                            .opacity(0.5)
                            .ignoresSafeArea()
                        
                        ScrollView {
                            Section {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.white)
                                    .overlay {
                                        RectanglePlusButton.preview
                                            .padding(30)
                                    }
                                    .frame(height: 150)
                            } header: {
                                Text("Rectangle Plus Button").sectionTitleStyle()
                            }
                        }
                        
                        .safeAreaPadding(EdgeInsets(top: 20, leading: 0, bottom: 150, trailing: 0))
                        .navigationTitle("Buttons")
                        #if os(macOS)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Buttons").font(.headline)
                            }
                        }
                        .listStyle(.inset)
                        #else
                        .navigationBarTitleDisplayMode(.inline)
                        .scrollContentBackground(.hidden)
                        .listStyle(.insetGrouped)
                        #endif
                    }
                    .tabItem {
                        Image(systemName: "star")
                        Text("Buttons")
                    }
                    
            ZStack {
                gradient
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ScrollView {
                    Section {
                        ShadowButtonPreview().frame(maxWidth: .infinity)
                    } header: {
                        Text("Shadow button").sectionTitleStyle()
                    }
                    
                    Section {
                        TexturedViewPreview()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    } header: {
                        Text("Textured buttons").sectionTitleStyle()
                    }
                }
                
                .safeAreaPadding(EdgeInsets(top: 20, leading: 0, bottom: 150, trailing: 0))
                .navigationTitle("Button modifiers")
                #if os(macOS)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Button modifiers").font(.headline)
                    }
                }
                .listStyle(.inset)
                #else
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                #endif
            }
            .tabItem {
                Image(systemName: "pencil.line")
                Text("Styles")
            }
        }
        
        
//        LinearGradient(
//            gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )
//        .edgesIgnoringSafeArea(.all)
//        .overlay {
//            TabView {
//                List {
//                    Section {
//                        ShadowButtonPreview()
//                    } header: {
//                        Text("Button 1").sectionTitleStyle()
//                    }
//                }
//                .tabItem {
//                    Label("Buttons", systemImage: "list.dash")
//                }
//                .navigationTitle("Buttons")
//                .navigationBarTitleDisplayMode(.inline)
//                .scrollContentBackground(.hidden)
//                
//                List {
//                    Section {
//                        ShadowButtonPreview()
//                    } header: {
//                        Text("Shadow button").sectionTitleStyle()
//                    }
//                }
//                
//                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
//                .navigationTitle("Cards")
//                .navigationBarTitleDisplayMode(.inline)
//                .scrollContentBackground(.hidden)
//                .listStyle(.insetGrouped)
//                .tabItem {
//                    Label("Styles", systemImage: "list.dash")
//                }
//            }
//            
//        }
    }
    
    static private var backgrounds: some View {
        return TabView {
            MoonlightGradientBackground()
                .tabItem {
                    VStack {
                        Image(systemName: "person.and.background.striped.horizontal")
                        Text("Moonlight")
                    }
                }
                    
            DayOrNightWithFirefliesBackground.preview
                .tint(.black)
            .tabItem {
                VStack {
                    Image(systemName: "person.and.background.striped.horizontal")
                    Text("Day/Night")
                }
            }
        }.tint(.white)
    }
    
    static private var nonInteractiveComponents: some View {
        let gradient = LinearGradient(colors: [.orange, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
        return ZStack {
            gradient
                .opacity(0.5)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                List {
                    Section {
                        StampView.preview.frame(maxWidth: .infinity)
                    } header: {
                        Text("Stamp view").sectionTitleStyle()
                    }
                }.listRowBackground(Color.red.opacity(0.2))
                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 150, trailing: 0))
                .navigationTitle("Non interactive components")
                #if os(macOS)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Non interactive components").font(.headline)
                    }
                }
                .listStyle(.inset)
                #else
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                #endif
                .background(.blue)
            }
        }
    }
    
    static private var effects: some View {
        return TabView {
            BubbleEffectView.preview
                .tabItem {
                    VStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                        Text("Bubbles")
                    }
                }
            
            PeelEffect<AnyView>.preview
                .tabItem {
                    VStack {
                        Image(systemName: "lanyardcard.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                        Text("Sticker")
                    }
                }
        }
    }
    
    static private var menus: some View {
        SplitViewPreview().frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TabBars: View {
    @State private var isBouncyTabBarSheetPresented = false // Controla la hoja modal
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay {
            List {
                Text("Scrollable tab bar").sectionTitleStyle(.dark)
                ScrollableTabBar.preview
                
                Text("Chip tab bar").sectionTitleStyle(.dark)
                ChipTabBarPreview()
                
            #if os(iOS)
                Text("Bouncy tab bar").sectionTitleStyle(.dark)
                Button("Show Bouncy Tab Bar") {
                    isBouncyTabBarSheetPresented = true
                }
                .sheet(isPresented: $isBouncyTabBarSheetPresented) {
                    BouncyTabBar.preview
                        .presentationDetents([.medium, .large]) // Ajusta los tamaños disponibles para la hoja
                        .presentationDragIndicator(.visible) // Muestra el indicador para arrastrar la hoja
                }
                #endif
            }
            .navigationTitle("Tab Bars")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            #endif
        }
    }
}


private struct CellsView: View {
    @State private var selectedTab: String = "Basic"
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay {
            VStack {
                ScrollableTabBar(tabs: ["Basic", "Liquid"], selectedTab: $selectedTab)
                
                switch selectedTab {
                    case "Basic":
                        List {
                            Text("Basic Cell").sectionTitleStyle(.dark)
                            BasicCellWithIcon.preview
                        }
                        .scrollContentBackground(.hidden)
                    case "Liquid":
                        LiquidViewCell.preview
//                            .scrollContentBackground(.hidden)
                            #if os(iOS)
                            .listStyle(.grouped)
                            #endif
                    default:
                        EmptyView().opacity(0)
                }
            }
            .navigationTitle("Cells")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

struct Carousles: View {
    private let gradient = LinearGradient(colors: [.orange, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
    
    var body: some View {
        ZStack {
            gradient
                .opacity(0.5)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                List {
                    Section {
                        LeftAlignedCarouselPreviewView()
                            .background(.yellow)
                            .frame(width: geometry.size.width, height: 320)
                            .padding(.horizontal, 30)
                    } header: {
                        Text("Left aligned carousel (Step by Step)").sectionTitleStyle()
                    }
                    
                    Section {
                        SnapCarouselView.preview
                            .background(.yellow)
                            .frame(width: geometry.size.width, height: 400)
                            .padding(.horizontal, 30)
                    } header: {
                        Text("Left aligned carousel (Step by Step)").sectionTitleStyle()
                    }
                    
                    // Link para mostrar CardsrouselView en una nueva pantalla
                    NavigationLink(destination: CardsrouselPreview()) {
                        Text("Show draggable cards")
                    }
                    .padding(.vertical)
                }
                .listRowBackground(Color.red.opacity(0.2))
                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 150, trailing: 0))
                .navigationTitle("Carousels")
                #if os(macOS)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Carousels").font(.headline)
                    }
                }
                .listStyle(.inset)
                #else
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                #endif
                .background(.blue)
            }
        }
    }
}
