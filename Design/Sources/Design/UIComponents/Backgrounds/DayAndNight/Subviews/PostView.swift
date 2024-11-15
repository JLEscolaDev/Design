//
//  PostView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//
import SwiftUI

struct PostView : View {
    @Binding var post : Post
    @Binding var isDetailed : Bool
    var body : some View {
//        ZStack {
//            if isDetailed {
//                DayNightToggleBackground(isDay: .constant(false))
//            }
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    Text(post.subtitle)
                        .foregroundStyle(isDetailed ? .white : .black)
                    Spacer()
                    
                    // Only show close button if page is showing in full screen
                    if(self.isDetailed) {
                        // Close Button
                        Button(action: {
                            self.post.showDetails.toggle()
                            self.isDetailed.toggle()
                        }) {
                            Text("X")
                                .frame(width: 48, height: 48, alignment: .center)
                                .background(Color.white)
                                .clipShape(Circle())
                        }.buttonStyle(PlainButtonStyle())
                    }
                }.padding([.top, .horizontal])
                
                Text(post.title).padding([.horizontal, .bottom])
                    .foregroundStyle(isDetailed ? .white : .black)
                if isDetailed {
                    Text(post.extra).padding([.horizontal, .bottom])
                        .foregroundStyle(isDetailed ? .white : .black)
                    Spacer()
                }
            }
            .background{
                if isDetailed { DayNightToggleBackground(isDay: $isDetailed) }
                else { Color.white }
            }
            .cornerRadius(isDetailed ? 0 : 16)
            .shadow(radius: isDetailed ? 0 : 12)
            .padding(isDetailed ? [] : [.top, .horizontal])
            .edgesIgnoringSafeArea(.all)
//        }
    }
}
