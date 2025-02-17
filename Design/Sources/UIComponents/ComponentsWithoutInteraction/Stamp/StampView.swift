//
//  Stamp.swift
//  masOcio
//
//  Created by Jose Luis Escolá García on 25/7/24.
//

import SwiftUI

/// `StampView` is a view that represents various stamp styles such as `default`, `antiqueStamp`, and `degradedAntiqueStamp`.
/// The view uses an enum `Style` to determine the style and content of the stamp.
public struct StampView: View {
    
    /// Stamp styles
    public enum Style {
        /// Custom style with just a custom shape with a tintable stroke
        case `default`(strokeColor: Color)
        
        /// Common stamp texture build from SVG that can hold a custom view inside it for personalization.
        case antiqueStamp(_ personalizedInsideSeal: () -> any View)
        
        /// Common stamp (with a little bit more degraded texture) build from SVG that can hold a custom view inside it for personalization.
        case degradedAntiqueStamp(_ personalizedInsideSeal: () -> any View)
    }
    
    let style: Style
    
    public var body: some View {
        
            switch style {
                case .default(let strokeColor):
                    GeometryReader { geometry in
                        ZStack {
                            StampShape().fill(strokeColor)
                            StampShape()
                                .frame(width: geometry.size.width*0.9, height: geometry.size.height*0.9)
                        }
                    }
                    
                case .antiqueStamp(let inside):
                    createStampFrom(Image(.stamp), personalizedContent: inside)
                    
                case .degradedAntiqueStamp(let inside):
                    createStampFrom(Image(.stamp2), personalizedContent: inside)
            }
    }
    
    /// Creates a "stamp texture" from the selected image and using the custom content if needed
    private func createStampFrom(_ image: Image?, personalizedContent: (() -> any View)) -> some View {
        AntiqueStamp {
            image?.resizable()
        } personalizedStampInside: {
            AnyView(personalizedContent())
        }
    }
}

fileprivate struct AntiqueStamp<Content: View, Inside: View>: View {
    @ViewBuilder var stamp: Content
    @ViewBuilder var personalizedStampInside: Inside
    var body: some View {
        /// The geometry  is need for the mask size (because it is not able to inherit the frame by itself)
        GeometryReader { geometry in
            ZStack {
                stamp
                personalizedStampInside
                    .mask {
                        stamp.frame(width: geometry.size.width, height: geometry.size.height)
                    }
            }
        }
    }
}

extension StampView {
    public static var preview: some View {
        VStack {
            Group {
                StampView(style: .default(strokeColor: .red)).foregroundStyle(.black)
                StampView(style: .antiqueStamp {
                    VStack(spacing:0) {
                        Text("+Ocio").font(.system(size: 20, weight: .heavy))
                            .foregroundStyle(.black)
                        Image(systemName: "figure.play")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.yellow)
                    }.rotationEffect(.degrees(-25))
                        
                }).foregroundStyle(.green)
                
                StampView(style: .degradedAntiqueStamp {
                    Text("+Ocio").rotationEffect(.degrees(25)).font(.system(size: 25, weight: .heavy))
                        .foregroundStyle(Color(red: 0, green: 30/255, blue: 101/255))
                        
                }).foregroundStyle(.blue)

            }.frame(width: 200, height: 200)
        }
    }
}

#Preview {
    StampView.preview
}
