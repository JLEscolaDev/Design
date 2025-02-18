//
//  DynamicBox.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//


//
//  DynamicBox.swift
//  masOcio
//
//  Created by Jose Luis Escolá García on 26/7/24.
//

import SwiftUI

struct DynamicBox: View {
    @Namespace var animation
    @State private var selectedCard: Int = -1
    @State private var openCard: Bool = false
    @State private var dragOffset: CGFloat = 0
    let cards: [MultiplatformImage]
    let detailData: [InfoCard]
    
    init(cards: [InfoCard]) {
        self.cards = cards.map { $0.snapshot(size: CGSize(width: 380, height: 500)) }
        self.detailData = cards
    }
    
    var body: some View {
        if openCard {
            detailData[selectedCard]
//                .matchedGeometryEffect(id: "card0", in: animation)
//                .matchedGeometryEffect(id: "card1", in: animation)
//                .matchedGeometryEffect(id: "card2", in: animation)
//                .matchedGeometryEffect(id: "card3", in: animation)
                .simultaneousGesture(
                    openCard ? DragGesture()
                        .onChanged { gesture in
                            
                            withAnimation {
                                if gesture.translation.height > 120 {
                                    withAnimation {
                                        openCard = false
                                        if openCard == false {
                                            withAnimation(.bouncy(duration:0.7, extraBounce: 0.1)) {
                                                dragOffset = -50
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                withAnimation(.bouncy(duration:0.7)) {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
//                                        dragOffset = -5
//                                        dragOffset = gesture.translation.height
                                    }
                                } //else {
                                  //  withAnimation {
                                  //      dragOffset = 0
                                  //  }
                                //}
                            }
                        } : nil
                )
                .simultaneousGesture( 
                    openCard ? MagnifyGesture()
                        .onChanged { value in
                            if openCard == true && value.velocity < -1 && value.magnification < 0.5 {
                                withAnimation {
                                    openCard = false
                                    if openCard == false {
                                        withAnimation(.bouncy(duration:0.7, extraBounce: 0.1)) {
                                            dragOffset = -50
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            withAnimation(.bouncy(duration:0.7)) {
                                                dragOffset = 0
                                            }
                                        }
                                    }
//                                        dragOffset = -5
//                                        dragOffset = gesture.translation.height
                                }
                            }
                        } : nil
                )
        } else {
            ZStack {
                Image("Background Open Box")
                
                addCard(cardIndex: 0,
                        width: 110,
                        height: 145,
                        yOffset: 125)
//                .matchedGeometryEffect(id: "card0", in: animation)
                addCard(cardIndex: 1,
                        width: 140,
                        height: 175,
                        yOffset: 80)
//                .matchedGeometryEffect(id: "card1", in: animation)
                addCard(cardIndex: 2,
                        width: 170,
                        height: 200,
                        yOffset: 40)
//                .matchedGeometryEffect(id: "card2", in: animation)
                addCard(cardIndex: 3,
                        width: 200,
                        height: 220,
                        yOffset: 0)
//                .matchedGeometryEffect(id: "card3", in: animation)
                Image("Front Open Box").offset(y: 125).zIndex(dragOffset == 0 ? 2 : 1)
            }
        }
    }
    
    private func addCard(
        cardIndex: Int,
        width: CGFloat,
        height: CGFloat,
        yOffset: CGFloat
    ) -> some View {
        let isCardSelected = selectedCard == cardIndex
        return VStack {
            if selectedCard != cardIndex {
                Spacer().allowsHitTesting(false)
            }
        Button(action: {
            cardTapped(cardIndex)
        }, label: {
//            let newWidth = selectedCard == cardIndex ? 220 : width
            let newHeight = isCardSelected && selectedCard != 0 ? height*1.1 : height
            let topPadding:CGFloat = isCardSelected && selectedCard == 0 ? 15 : 0
           
            cards[cardIndex].toImage
                .resizable()
                .frame(width: isCardSelected ? width+abs(dragOffset) : width, height: isCardSelected ?  newHeight+abs(dragOffset*1.5) : newHeight)
                .drawingGroup()
                .rotation3DEffect(
                    .degrees(isCardSelected ? limitedRotation : 0),
                    axis: (x: 1.0, y: 0.0, z: 0.0),
                    anchorZ: 0,
                    perspective: 1
                )
//                .aspectRatio(contentMode: .fit)
                
                    .padding(.top, topPadding)
                    .padding(.bottom, yOffset)
                    .offset(y: isCardSelected ? limitedRotation*0.8 : 0)
                    .simultaneousGesture(
                        isCardSelected ? MagnifyGesture()
                            .onChanged { value in
                                if !openCard == true && value.magnification > 1 {
                                    withAnimation(.bouncy(duration:0.7, extraBounce: 0.1)) {
                                        dragOffset = -50
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.bouncy(duration:0.7)) {
                                            dragOffset = -150
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            openCard = true
                                        }
                                    }
                                }
                            } : nil
                    )
                    .simultaneousGesture(
                        isCardSelected ? DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.height < 0 {
                                    dragOffset = gesture.translation.height
                                }
//                                withAnimation {
//                                    print(gesture.translation.height)
                                    if gesture.translation.height < -150 {
                                        withAnimation(.bouncy(duration:0.7, extraBounce: 0.1)) {
                                            openCard = true
                                        }
                                    } else if gesture.translation.height > 50 {
                                        withAnimation {
                                            selectedCard = -1
                                        }
                                    }
//                                }
                            }.onEnded { gesture in
                                if openCard == false {
                                    withAnimation(.bouncy(duration:0.7, extraBounce: 0.1)) {
                                        dragOffset = -50
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation(.bouncy(duration:0.7)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                            } : nil
                    )
                    
//                    .modifier(AspectRatioModifier(selectedCard == cardIndex ? .fit : .none))
            
//                .offset(y: offset)
        })
            if selectedCard == cardIndex {
                Spacer().allowsHitTesting(false)
            }
        }.frame(height: 440)
            .zIndex(isCardSelected && dragOffset != 0 ? 2 : 1)
    }
    
    var limitedRotation: CGFloat {
            let maxDrag: CGFloat = 75
            let maxRotation: CGFloat = 75
            
            let normalizedDrag = dragOffset / maxDrag
            let rotation = normalizedDrag * maxRotation
            
            if rotation > maxRotation {
                return maxRotation - (rotation - maxRotation)
            } else if rotation < -maxRotation {
                return -maxRotation - (rotation + maxRotation)
            }
            
            return rotation
        }

    private func cardTapped(_ index: Int) {
        if selectedCard == index {
            selectedCard = -1
        }else {
            selectedCard = index
        }
    }
}

#Preview {
    DynamicBox.preview
}

extension DynamicBox {
    public static var preview: some View {
        let cards = [
            InfoCard(vm: .init(id: 0, image: Image(.test), title: "Acampada a las afueras de la ciudad para mirar las estrellas", description: "Escápate con tus amigos y acampa bajo un cielo lleno de estrellas. Enciende una hoguera, comparte historias, y contempla la Vía Láctea lejos de las luces de la ciudad. ¡Una noche mágica que no te puedes perder!", subtitle: "10 planes restantes", style: .default)),
            
            InfoCard(vm: .init(id: 1, image: Image(.test2), title: "Acampada a las afueras de la ciudad para mirar las estrellas", description: "Escápate con tus amigos y acampa bajo un cielo lleno de estrellas. Enciende una hoguera, comparte historias, y contempla la Vía Láctea lejos de las luces de la ciudad. ¡Una noche mágica que no te puedes perder!", subtitle: "10 planes restantes", style: .style2)),
            
            InfoCard(vm: .init(id: 2, image: Image(.test), title: "Acampada a las afueras de la ciudad para mirar las estrellas", subtitle: "10 planes restantes", style: .style3))
        ]
        
        return DynamicBox(cards: cards)
    }
}

extension View {
    func snapshot(size: CGSize) -> MultiplatformImage {
        #if os(iOS)
        let controller = UIHostingController(rootView: self.frame(width: size.width, height: size.height))
        let view = controller.view

        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear

        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.addSubview(view!)
        window.makeKeyAndVisible()

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        #else
        let controller = NSHostingController(rootView: self.frame(width: size.width, height: size.height))
        let view = controller.view

        view.frame = CGRect(origin: .zero, size: size)

        let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds)
        view.cacheDisplay(in: view.bounds, to: rep!)

        let image = NSImage(size: size)
        image.addRepresentation(rep!)
        return image
        #endif
    }
}

//private struct AspectRatioModifier: ViewModifier {
//    enum AspectRatio {
//        case fill
//        case fit
//        case none
//    }
//    var aspectRatio: AspectRatio
//    init(_ aspectRatio: AspectRatio) {
//        self.aspectRatio = aspectRatio
//    }
//    
//    func body(content: Content) -> some View {
//        switch aspectRatio {
//            case .fill:
//                content.aspectRatio(contentMode: .fill)
//            case .fit:
//                content.aspectRatio(contentMode: .fit)
//            case .none:
//                content
//        }
//    }
//}

#if os(iOS)
import SwiftUI
typealias HostingController = UIHostingController
#else
import SwiftUI
typealias HostingController = NSHostingController
#endif


import SwiftUI

struct TestView: View {
    @State var selectedForDetail : Post?
    @State var showDetails: Bool = false

    // Posts need to be @State so changes can be observed
    @State var posts = [
        Post(subtitle: "test1", title: "title1", extra: "Lorem ipsum dolor..."),
        Post(subtitle: "test1", title: "title1", extra: "Lorem ipsum dolor..."),
        Post(subtitle: "test1", title: "title1", extra: "Lorem ipsum dolor..."),
        Post(subtitle: "test1", title: "title1", extra: "Lorem ipsum dolor..."),
        Post(subtitle: "test1", title: "title1", extra: "Lorem ipsum dolor...")
    ]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.posts.indices) { index in
                    GeometryReader { reader in
                        PostView(post: self.$posts[index], isDetailed: self.$showDetails)
                        .offset(y: self.posts[index].showDetails ? -reader.frame(in: .global).minY : 0)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2)) {
                                if !self.posts[index].showDetails {
                                    self.posts[index].showDetails.toggle()
                                    self.showDetails.toggle()
                                }
                            }
                        }
                        // If there is one view expanded then hide all other views that are not
                        .opacity(self.showDetails ? (self.posts[index].showDetails ? 1 : 0) : 1)
                    }
                    .frame(height: self.posts[index].showDetails ? MultiplatformScreen.bounds.size.height : 100, alignment: .center)
                    .simultaneousGesture(
                        // 500 will disable ScrollView effect
                        DragGesture(minimumDistance: self.posts[index].showDetails ? 0 : 500)
                    )
                }
            }
        }.background(DayNightToggleBackground(isDay: .constant(false)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}










