//
//  Orientation.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//

import SwiftUI

public struct SplitView<TopContent: View, BottomContent: View>: View {
    public init(vm: SplitViewModel<TopContent, BottomContent>) {
        self.vm = vm
    }
    
    @State private var vm: SplitViewModel<TopContent, BottomContent>
    
    public var body: some View {
        GeometryReader { geometry in
            vm.calculateViewSizes(for: geometry)
            
            return VariableOrientationStack(orientation: vm.multiViewVM.variableOrientation) {
                vm.topContent
                    .frame(
                        width: vm.multiViewVM.firstViewSizes.width > 0 ? vm.multiViewVM.firstViewSizes.width : nil,
                        height: vm.multiViewVM.firstViewSizes.height > 0 ? vm.multiViewVM.firstViewSizes.height : nil
                    )
                
                MiddleDragNotch(vm: $vm.multiViewVM, parentGeometry: geometry)
                
                vm.bottomContent
                    .frame(
                        width: vm.multiViewVM.secondViewSizes.width,
                        height: vm.multiViewVM.secondViewSizes.height
                    )
            }
            #if os(iOS)
            .onRotate { newOrientation in
                let orientation: Orientation = newOrientation.isLandscape ? .horizontal : .vertical
                if orientation != vm.multiViewVM.deviceOrientation {
                    vm.multiViewVM.deviceOrientation = orientation
                    vm.multiViewVM.translation = .zero
                }
            }
            #endif
        }
        .background(.black)
    }
}

// - MARK: PREVIEW

#Preview {
    SplitViewPreview().ignoresSafeArea()
}

@_spi(Demo) public struct SplitViewPreview: View {
    public init() {}
    private let orientation: Orientation? = nil
    private let minSize: CGFloat = 150
    @State private var selectedSide: NotchPosition? = nil
    @State private var isWebViewPresented = false
    @State private var isLoading = false // State to control loader visibility
    
    public var body: some View {
        GeometryReader { geometry in
            SplitView(vm: .init(
                orientation: orientation,
                topContent:
                    ZStack {
                        Color.orange
                        Text("Drag from view sides")
                            .font(.title)
                            .padding(.top, 24)
                            .bold()
                    }
                    .withNotch(allowedSides: [.left, .right], notchFollowsTouch: false) { notchSide, drag in
                        selectedSide = notchSide
                        isWebViewPresented = true
                    }
                    .background(
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .yellow]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            VStack {
                                HStack {
                                    Text("Linkedin")
                                        .rotationEffect(.degrees(90))
                                    Spacer()
                                    Text("Github")
                                        .rotationEffect(.degrees(-90))
                                }.fontWeight(.heavy)
                            }
                        }
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    ),
                bottomContent:
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.red]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .background(.black)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                    ),
                minSize: minSize
            ))
        }
        .overlay(
            Group {
                if isWebViewPresented {
                    ZStack {
                        if selectedSide == .right {
                            #if os(iOS)
                            WebView(url: URL(string: "https://github.com/JLEscolaDev/DoomKanban")!, isLoading: $isLoading)
                                .edgesIgnoringSafeArea(.all)
                            #endif
                        }
                        
                        if isLoading {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                CircularProgressLoader(style: .expandingCircles)
                                    .background(.white)
                                    .transition(.opacity) // Smooth fade-in/out
                            }
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    isWebViewPresented = false
                                    isLoading = false
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                .padding()
                            }
                            Spacer()
                        }
                    }
                    .transition(.opacity)
                }
            }
        ).onChange(of: selectedSide) { oldValue, newValue in
            if newValue == .left {
                openInBrowser(urlString: "https://es.linkedin.com/in/jose-luis-escol%C3%A1-garc%C3%ADa")
            }
        }
    }
    
    /// Opens default browser
    private func openInBrowser(urlString: String) {
        guard let url = URL(string: urlString) else {
            isWebViewPresented = false
            isLoading = false
            return
        }
        
        #if os(iOS)
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    isWebViewPresented = false
                    isLoading = false
                }
            }
        } else {
            isWebViewPresented = false
            isLoading = false
        }
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        isWebViewPresented = false
        isLoading = false
        #endif
    }
}
