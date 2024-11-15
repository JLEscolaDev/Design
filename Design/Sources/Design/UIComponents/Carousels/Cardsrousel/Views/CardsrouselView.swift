//
//  CardView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 13/11/24.
//
//import SwiftUI

import SwiftUI

public struct CardsrouselView: View {
    @State var data: CardsRouselData
    
    public var body: some View {
        GeometryReader { reader in
            ZStack {
                ForEach(data.cards) { card in
                    ColorCard(data: data, card: card, reader: reader)
                }
            }
        }
    }
}

public struct CardsrouselPreview: View {
    public init () {}
    private let data = CardsRouselData()
    public var body: some View {
        HStack {
            VStack {
                CardsrouselView(data: data)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(data)
    }
}

#Preview {
    CardsrouselPreview()
}
