//
//  DefaultInfoCard.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

struct DefaultInfoCard: View {
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
                        .frame(width: geometry.size.width, height: geometry.size.height*0.35)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if let title = title {
                            Text(title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .minimumScaleFactor(0.3)
                        }
                        if let description = description {
                            Text(description)
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .padding()
                    .background(Color.white)
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
