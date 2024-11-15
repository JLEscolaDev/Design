//
//  CarouselItemView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 4/11/24.
//
import SwiftUI

struct CarouselItemView: View {
    var image: Image?
    var title: String
    var buttonAction1: () -> Void
    var buttonAction2: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            image?
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 150)
                .clipped()
                .cornerRadius(20)
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                        .cornerRadius(20)
                )
                .shadow(radius: 5)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            HStack(spacing: 15) {
                Button(action: buttonAction1) {
                    Text("Join")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(15)
                }

                Button(action: buttonAction2) {
                    Text("Details")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray)
                        .cornerRadius(15)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(.vertical, 10)
    }
}
