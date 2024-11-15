//
//  TopView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//
import SwiftUI

struct TopView: View {
    let orientation: Orientation
    /// Used to display reduced layout when there is no too much space (height when `orientation` is `vertical` and width when `orientation` is `horizontal`)
    let minSize: CGFloat
    
    
    var body: some View {
        GeometryReader { geometry in
            /// Get height or width based on `orientation` to display layout based on the available space.
            let size = orientation == .vertical ? geometry.size.height : geometry.size.width
            VStack(alignment: .leading, spacing: 16) {
                if size > minSize {
                    Text("Hello, World!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .opacity(0.7)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("San Francisco")
                            .fontWeight(.medium)
                        
                        if size > minSize {
                            Text("Sunny")
                                .font(.caption)
                                .opacity(0.8)
                        }
                    }

                    Spacer()
                    
                    if size > minSize {
                        Image(systemName: "sun.max.fill")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }

                    Text("101°")
                        .font(.system(size: size > minSize ? 50 : 25 , weight: .bold, design: .rounded))
                }

                if size > minSize {
                    Text("Humidity: 80%")
                        .font(.caption)
                        .opacity(0.8)
                    Text("Wind: 10 mph NW")
                        .font(.caption)
                        .opacity(0.8)
                    Text("Precipitation: 5%")
                        .font(.caption)
                        .opacity(0.8)
                    Text("Air Quality: Moderate")
                        .font(.caption)
                        .opacity(0.8)
                }
            }
            .padding(20)
        }
    }
}
