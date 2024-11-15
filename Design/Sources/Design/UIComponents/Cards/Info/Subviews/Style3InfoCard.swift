//
//  Style3InfoCard.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

struct Style3InfoCard: View {
    var image: Image
    var title: String?
    var subtitle: String?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Text(title?.uppercased() ?? "")
                .multilineTextAlignment(.center)
                .font(.title2)
                .fontWeight(.black)
                .padding()
                .minimumScaleFactor(0.3)
            
            GeometryReader { geometry in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height*0.8)
                    .clipped()
            }
            
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white.opacity(0.95))
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
            }
        }
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .white, location: 0.20),
                    Gradient.Stop(color: Color(red: 0.83, green: 1, blue: 0.94), location: 0.45),
                    Gradient.Stop(color: Color(red: 0, green: 0.3, blue: 0.25), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 0.25)
                    .stroke(.black, lineWidth: 0.5)
            )
        )
    }
}
