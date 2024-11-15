//
//  BottomView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//
import SwiftUI

struct BottomView: View {
    let orientation: Orientation
    let minSize: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            /// Get height or width based on `orientation` to display layout based on the available space.
            let size = orientation == .vertical ? geometry.size.height : geometry.size.width
            VStack(alignment: .leading, spacing: 16) {
                Text("Weekly Forecast")
                    .font(.title2)
                    .fontWeight(.bold)
                    .opacity(0.7)
                
                if geometry.size.height > minSize {
                    ForEach(0..<5) { day in
                        HStack {
                            Text(getDay(for: day))
                            Spacer()
                            Image(systemName: "sun.fill")
                                .foregroundColor(.yellow)
                            Text("7\(day + (day % 2) * 4)°")
                        }
                    }

                    Spacer()
                    
                    Text("Weather data provided by OpenWeatherMap.")
                        .font(.footnote)
                        .opacity(0.5)
                }
            }
            .padding(20)
        }
    }

    func getDay(for index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = Calendar.current.date(byAdding: .day, value: index, to: Date())!
        return dateFormatter.string(from: day)
    }
}
