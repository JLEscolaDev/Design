//
//  DayNightCellsView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 10/12/24.
//


import SwiftUI

public struct DayNightCellsView: View {
    @State private var selectedForDetail : Post?
    @State private var showDetails: Bool = false
    @State var posts: [Post]
    
    public init(posts: [Post]) {
        self.posts = posts
    }
//    parece que tengo problemas en la app principal. No puedo meter esta vista en nada que no sea  pantalla completa porque coge todo el tamaño de la pantalla en vez del tamaño de la vista que lo invoca.
    public var body: some View {
        GeometryReader { geometry in
        ScrollView {
            VStack(spacing: 10) {
                ForEach(self.posts.indices) { index in
                    GeometryReader { reader in
                        PostView(post: self.$posts[index], isDetailed: self.$showDetails)
//                            .position(CGPoint(x: geometry.size.width/2, y: self.posts[index].showDetails ? -reader.frame(in: .global).minY : 0))
//                            .offset(y: self.posts[index].showDetails ? -reader.frame(in: .global).minY : 0)
                            
//                            .offset(y: self.posts[index].showDetails ? -geometry.size.height/2+100 : 0)
                            .onTapGesture {
                                if !self.posts[index].showDetails {
                                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.2)) {
                                        self.posts[index].showDetails.toggle()
                                    }
                                    
                                    self.showDetails.toggle()
                                }
                            }
                            .offset(y: self.posts[index].showDetails ? -CGFloat(index*100)-CGFloat(index*10) : 0.0)
//                            .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2))
                        // If there is one view expanded then hide all other views that are not
                            .opacity(self.showDetails ? (self.posts[index].showDetails ? 1 : 0) : 1)
                    }
                    
                    .frame(height: self.posts[index].showDetails ? geometry.size.height : 100, alignment: .top)
                    .simultaneousGesture(
                        // 500 will disable ScrollView effect
                        DragGesture(minimumDistance: self.posts[index].showDetails ? 0 : 500)
                    )
                }
            }
        }.background(DayNightToggleBackground(isDay: .constant(false)))
        }.scrollDisabled(showDetails)
    }
}

extension DayNightCellsView {
    public static var preview: some View {
        DayNightCellsView(posts: [
            Post(subtitle: "Breaking News", title: "World Economy Updates", extra: "Experts predict a steady recovery..."),
            Post(subtitle: "Tech Insights", title: "AI Revolution in 2024", extra: "Discover how AI is transforming..."),
            Post(subtitle: "Health Tips", title: "5 Ways to Boost Immunity", extra: "Stay healthy with these daily habits..."),
            Post(subtitle: "Travel Guide", title: "Top Destinations for 2024", extra: "Explore exotic locations this year..."),
            Post(subtitle: "Entertainment Buzz", title: "Upcoming Blockbusters", extra: "Check out the most anticipated movies...")
        ])
    }
}

#Preview {
    DayNightCellsView.preview
}










