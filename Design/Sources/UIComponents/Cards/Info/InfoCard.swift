//
//  Constants.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//


import SwiftUI

public struct InfoCard: View, Identifiable {
    public init(vm: InfoCardViewModel) {
        self.vm = vm
    }
    
    public enum InfoCardStyle {
        case `default`
        case style2
        case style3
    }
    
    let vm: InfoCardViewModel
    public var id: Int {
        vm.id
    }
    
    public var body: some View {
        switch vm.style {
            case .default:
                DefaultInfoCard(image: vm.image, title: vm.title, description: vm.description, subtitle: vm.subtitle)
            case .style2:
                OverlayInfoCard(image: vm.image, title: vm.title, description: vm.description, subtitle: vm.subtitle)
            case .style3:
                Style3InfoCard(image: vm.image, title: vm.title, subtitle: vm.subtitle)
        }
    }
}

// - MARK: Preview

extension InfoCard {
    public static var preview: some View {
        let infoData = [
            InfoCard(vm: .init(id: 0, image: Image(.test), title: "Acampada a las afueras de la ciudad para mirar las estrellas", description: "Escápate con tus amigos y acampa bajo un cielo lleno de estrellas. Enciende una hoguera, comparte historias, y contempla la Vía Láctea lejos de las luces de la ciudad. ¡Una noche mágica que no te puedes perder!", subtitle: "10 planes restantes", style: .default)),
            
            InfoCard(vm: .init(id: 1, image: Image(.test2), title: "Acampada a las afueras de la ciudad para mirar las estrellas", description: "Escápate con tus amigos y acampa bajo un cielo lleno de estrellas. Enciende una hoguera, comparte historias, y contempla la Vía Láctea lejos de las luces de la ciudad. ¡Una noche mágica que no te puedes perder!", subtitle: "10 planes restantes", style: .style2)),
            
            InfoCard(vm: .init(id: 2, image: Image(.test), title: "Acampada a las afueras de la ciudad para mirar las estrellas", subtitle: "10 planes restantes", style: .style3))
        ]
        
        return ScrollView(.horizontal) {
            HStack(spacing: 50) {
                ForEach(infoData) { info in
                    info.frame(width: 280, height: 400)
                }
            }
            .frame(height: 420)
            .padding(20)
        }
    }
}

#Preview {
    InfoCard.preview
}
