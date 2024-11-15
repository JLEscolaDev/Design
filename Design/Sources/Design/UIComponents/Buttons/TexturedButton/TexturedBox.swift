//
//  TexturedBox.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//

import SwiftUI

public struct TexturedView<T: View>: View {
    public init(vm: TexturedViewModel, @ViewBuilder view: @escaping () -> T) {
        self.vm = vm
        self.view = view()
    }
    
    private var vm: TexturedViewModel
    @ViewBuilder private var view: T

    public var body: some View {
        view
        /// We use overlay to set the texture over the text. We can extract the .tiledBackground to be behind the text
        .overlay {
            Color.clear
                .tiledBackground(
                    with: vm.texture,
                    capInsets: EdgeInsets(all: vm.capInsets),
                    withOpacity: vm.opacity
                ).allowsHitTesting(false)
        }
    }
}



// - MARK: PREVIEW

@_spi(Demo) public struct TexturedViewPreview: View {
    public init () {}
    
    @State private var scratchButtonTextureOpacity: Double = 0
    @State private var rustButtonTextureOpacity: Double = 0
    
    public var body: some View {
        VStack {
            HStack {
                TexturedView(vm: .init(texture: Image(.abstractScratchTexture), opacity: scratchButtonTextureOpacity, capInsets: 20)) {
                    Button(action: {
                        if scratchButtonTextureOpacity <= 1 {
                            scratchButtonTextureOpacity += 0.05
                        }
                    }, label: {
                        VStack {
                            Text("Push for").font(.title).foregroundStyle(.white)
                                .fontWeight(.bold)
                            Text("texture").foregroundStyle(.black)
                        }
                    }).padding()
                }.background(.cyan)
                    .cornerRadius(25)
                
                TexturedView(vm: .init(texture: Image(.abstractScratchTexture), opacity: scratchButtonTextureOpacity, capInsets: 20)) {
                    Button(action: {
                        if scratchButtonTextureOpacity <= 1 {
                            scratchButtonTextureOpacity += 0.05
                        }
                    }, label: {
                        VStack {
                            Text("scratch").font(.title).foregroundStyle(.white)
                                .fontWeight(.bold)
                            Text("texture").foregroundStyle(.black)
                        }
                    }).padding()
                }.background(.cyan)
                    .cornerRadius(25)
                    .foregroundStyle(.white)
            }
            
            TexturedView(vm: .init(texture: Image(.lightTextureMappingRustTransparencyAndTranslucencyAlpha), opacity: rustButtonTextureOpacity, capInsets: 20)) {
                Button(action: {
                    if rustButtonTextureOpacity <= 1 {
                        rustButtonTextureOpacity += 0.05
                    }
                }, label: {
                    VStack {
                        Text("Rust").font(.title).foregroundStyle(.black)
                        Text("textured button").foregroundStyle(.black)
                    }
                }).padding()
            }.background(.yellow)
                .cornerRadius(15)
            
            TexturedView(vm: .init(texture: Image(.leatherMacroShot), opacity: 0.8, capInsets: 20)) {
                Button(action: {
                    print("Leather")
                }, label: {
                    VStack {
                        Text("Leather").font(.title).foregroundStyle(.white)
                        Text("textured button").foregroundStyle(.green.opacity(0.7).darker())
                    }
                }).padding()
            }.blendMode(.plusLighter).background(.green.darker(by: 0.65))
                .cornerRadius(25)
        }
    }
}

#Preview {
    TexturedViewPreview()
}
