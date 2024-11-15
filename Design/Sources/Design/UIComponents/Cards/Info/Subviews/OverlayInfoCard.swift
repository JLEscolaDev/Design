//
//  OverlayInfoCard.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

struct OverlayInfoCard: View {
    var image: Image
    var title: String?
    var description: String?
    var subtitle: String?
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            
            VStack(spacing: 0) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(width: geometry.size.width ,height: geometry.size.height*0.6)
                    .overlay {
                        if let title = title {
                            Rectangle()
                                .blur(radius: 3)
                                .background(
                                    .ultraThinMaterial,
                                    in: Rectangle()
                                )
                                .overlay {
                                    Rectangle()
                                        .fill(.white)
                                }
                                .opacity(0.7)
                                .overlay {
                                    Text(title)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding()
                                }.padding()
                        }
                    }
                if let description = description {
                    Text(description)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.white)
                        .minimumScaleFactor(0.5)
                }
                
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black.opacity(0.95))
                        .padding(.horizontal, 10)
                        .minimumScaleFactor(0.5)
                }
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
        }
        }
    }
}
