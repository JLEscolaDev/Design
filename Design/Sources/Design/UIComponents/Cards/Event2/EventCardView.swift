//
//  EventCardView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

public struct EventCardView: View {
    public init(event: Event) {
        self.event = event
    }
    
    var event: Event

    public var body: some View {
        HStack(spacing: 15) {
            VStack {
                Text(event.date, style: .date)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(event.date, style: .time)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(Color(hex: "#FF5E3A"))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 5) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Estadio Central")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Button(action: {
                // Acción de agregar al calendario
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(hex: "#FFD700")) // Especificar el inicializador hex
                    .shadow(radius: 5)
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#0072FF"), Color(hex: "#00C6FF")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}

extension EventCardView {
    public static var previews: some View {
        EventCardView(event: .init(name: "Event Name", date: Date()))
            .padding(.horizontal, 10)
    }
}

#Preview {
    EventCardView.previews
}
