//
//  CategoryButtonCard.swift
//  masOcio
//
//  Created by Jose Luis Escolá García on 24/7/24.
//

import SwiftUI

public struct SquareCard: View {
    public enum BackgroundGradientStyle {
        case circular(color: Color)
        case linear(topColor: Color, bottomColor: Color)
    }
    
    private let image: Image?
    private let text: String
    private let color: BackgroundGradientStyle
    private let circleIcon: Image?
    private var circleStrokeColor: Color = .black
    
    private var frame: CGSize? = nil
    private var font: Font = .system(size: 20, weight: .bold)
    private var tintColor: Color = .white
    
    /// Initializer without frame
    public init(icon: Image? = nil, image: Image? = nil, text: String, color: BackgroundGradientStyle) {
        self.circleIcon = icon
        self.image = image
        self.text = text
        self.color = color
        switch color {
            case .circular(let color):
                self.circleStrokeColor = color

            case .linear(_, let bottomColor):
                self.circleStrokeColor = bottomColor
        }
    }

    /// Initializer with frame
    public init(icon: Image? = nil, image: Image? = nil, text: String, color: BackgroundGradientStyle, frame: CGSize) {
        self.init(icon: icon, image: image, text: text, color: color)
        self.frame = frame
    }

    public var body: some View {
        GeometryReader { geometry in
            let maxSize = max(geometry.size.width, geometry.size.height)
            let minSize = min(geometry.size.width, geometry.size.height)
            let size = minSize * 2.5 > maxSize ? minSize : minSize / 2
            let imageSize = size * 0.75
            let insideLineCornerRadius: CGFloat = 20
            let innerRectangleHeight = geometry.size.height - imageSize / 2
            let padding: CGFloat = 5
            let mainCardCornerRadius: CGFloat = insideLineCornerRadius + padding
            ZStack {
                VStack {
                    Spacer()
                    ZStack {
                        switch color {
                            case .circular(let color):
                                ShadowCardRectangle(color: color, radius: mainCardCornerRadius)
                            case .linear(let topColor, let bottomColor):
                                LinearGradient(
                                    gradient: Gradient(colors: [topColor, bottomColor]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .clipShape(RoundedRectangle(cornerRadius: mainCardCornerRadius))
                        }
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(Color(red: 0.6, green: 1, blue: 0.53).opacity(0))
                            .overlay(RoundedRectangle(cornerRadius: insideLineCornerRadius)
                                .inset(by: 3)
                                .stroke(.white, lineWidth: 6))
                            .background {
                                VStack(spacing: 0) {
                                    if let image {
                                        image
                                            .resizable()
                                            .frame(height: innerRectangleHeight / 2)
                                        
                                        Divider()
                                    }
                                    Spacer()
                                    Text(text)
                                        .font(font)
                                        .foregroundColor(tintColor)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .padding(.bottom, geometry.size.height * 0.05)
                                    Spacer()
                                }
                            }
                            .clipped()
                            .cornerRadius(20)
                            .padding(padding)
                    }.frame(height: innerRectangleHeight)
                }.frame(height: geometry.size.height)
                if let circleIcon {
                    VStack {
                        Circle()
                            .stroke(circleStrokeColor, lineWidth: 2)
                            .background(Circle().fill(Color.white))
                            .overlay(
                                circleIcon
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                                    .frame(width: imageSize * 0.8, height: imageSize * 0.8)
                            )
                            .frame(width: imageSize, height: imageSize)
                            .offset(y: -(imageSize / 100))
                        
                        Spacer()
                    }.frame(height: geometry.size.height)
                }
            }
        }
        .frame(width: frame?.width, height: frame?.height)
    }

    // Custom modifier for font
    public func font(_ font: Font) -> SquareCard {
        var copy = self
        copy.font = font
        return copy
    }

    // Custom modifier for tint color
    public func tintColor(_ tintColor: Color) -> SquareCard {
        var copy = self
        copy.tintColor = tintColor
        return copy
    }
}

extension SquareCard {
    public static var preview: some View { CategoryButtonCard_Preview() }
}

struct CategoryButtonCard_Preview: View {
    var body: some View {
        ScrollView(.horizontal) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Circular gradient").font(.title).fontWeight(.bold)
                    HStack {
                        Button(action: {},
                               label: {
                            SquareCard(
                                icon: Image(systemName: "square.and.arrow.up.fill"),
                                image: Image(.test3Vector),
                                text: "Seguridad y emergencias",
                                color: .circular(
                                    color: .green
                                )
                            )
                            .frame(width: 165, height: 260)
                        }).tint(.green)
                        Button(action: {}, label: {
                            SquareCard(image: Image(.test3Vector), text: "Seguridad y emergencias", color: .linear(topColor: Color(red: 0.6, green: 1, blue: 0.53), bottomColor: Color(red: 0.07, green: 0.46, blue: 0)))
                                .frame(width: 165, height: 260)
                        }).tint(.green)
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Vertical gradient").font(.title).fontWeight(.bold)
                    HStack(spacing: 30) {
                        SquareCard(
                            icon: Image(systemName: "car.fill"),
                            image: Image(.test3Vector), text: "Text alert!! Text alert!! Text alert!! Text alert!! Text alert!! Text alert!! Text alert!! Text alert!! Text alert!! Text alert!! Text alert!! Text alert!!", color: .circular(color: .blue))
                        .foregroundStyle(.blue)
                        .frame(width: 300, height: 400)
                        SquareCard(image: Image(.test2), text: "This is a sample text for our SquareCard", color: .circular(color: .green))
                            .frame(width: 150, height: 200)
                        SquareCard(
                            icon: Image(systemName: "carbon.monoxide.cloud.fill"),
                            image: Image("97920"), text: "Text alert!!", color: .circular(color: .red))
                        .frame(width: 150, height: 150)
                        
                    }.padding(.horizontal, 20)
                    
                    Text("Simplified").font(.title).fontWeight(.bold)
                    HStack(spacing: 30) {
                        SquareCard(text: "Seguridad\ny\nemergencias", color: .linear(topColor: Color(red: 241/255, green: 237/255, blue: 49/255), bottomColor: Color(red: 255/255, green: 92/255, blue: 0/255)))
                            .font(.system(size: 10, weight: .semibold))
                            .tintColor(.black)
                            .frame(width: 110, height: 160)
                    }.padding(.horizontal, 20)
                }
            }
        }//.frame(height: 300)
    }
}

#Preview {
    CategoryButtonCard_Preview()
}


