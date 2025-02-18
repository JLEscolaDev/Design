//
//  RectanglePlustButton.swift
//  masOcio
//
//  Created by Jose Luis Escolá García on 26/7/24.
//

import SwiftUI

public struct RectanglePlusButton: View {
    public init(cornerRadius: CGFloat = 20) {
        self.cornerRadius = cornerRadius
    }
    
    var cornerRadius: CGFloat = 20
    private var tintColor: Color = .black
    
    // Default variables used to keep always same aspect ratio
    private let defaultFontSize: Double = 120
    private let defaultFrameSize: Double = 100
    private let defaultLineWidth: Double = 10
    
    public var body: some View {
        GeometryReader { geometry in
            let lineWidth = geometry.size.width * defaultLineWidth / defaultFrameSize
            let plusSize = geometry.size.width * defaultFontSize / defaultFrameSize
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
                .foregroundColor(tintColor)
                .overlay {
                    VStack(spacing: 0) {
                        Text("+")
                            .font(.system(size: plusSize, weight: .medium, design: .rounded))
                        Spacer()
                    }
                    .offset(y: -plusSize * 0.05) // Slight vertical offset to center the plus visually
                }
        }
    }
    
    // Custom modifier for tint color
    public func tintColor(_ tintColor: Color) -> RectanglePlusButton {
        var copy = self
        copy.tintColor = tintColor
        return copy
    }
}

// MARK: - PREVIEW

extension RectanglePlusButton {
    public static var preview: some View { RectanglePlusButtonPreview() }
}

#Preview {
    RectanglePlusButton.preview
}

fileprivate struct Option: Identifiable {
    let id: Int
    let view: AnyView?
}

@_spi(Demo) public struct RectanglePlusButtonPreview: View {
    @State private var selectedOptionLeft: Option?
    @State private var selectedOptionCenter: Option?
    @State private var selectedOptionRight: Option?
    
    @State private var isSelectingLeftOption = false
    @State private var isSelectingCenterOption = false
    @State private var isSelectingRightOption = false
    
    private let options: [Option] = [
        .init(id: 1, view: AnyView(Image(systemName: "star.fill").resizable().foregroundColor(.yellow))),
        .init(id: 2, view: AnyView(Image(systemName: "heart.fill").resizable().foregroundColor(.red))),
        .init(id: 3, view: nil)
    ]
    
    public var body: some View {
        GeometryReader { geometry in
            HStack {
                // Left Button
                Button(action: {
                    isSelectingLeftOption.toggle()
                }, label: {
                    if let selectedView = selectedOptionLeft?.view {
                        selectedView
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    } else {
                        RectanglePlusButton(cornerRadius: geometry.size.width * 0.025)
                            .tintColor(.yellow.opacity(0.3))
                            .foregroundStyle(.yellow)
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    }
                })
                .sheet(isPresented: $isSelectingLeftOption) {
                    OptionSelectionView(options: options) { option in
                        selectedOptionLeft = option
                        isSelectingLeftOption.toggle()
                    }
                }
                
                Spacer()
                
                // Center Button
                Button(action: {
                    isSelectingCenterOption.toggle()
                }, label: {
                    if let selectedView = selectedOptionCenter?.view {
                        selectedView
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                    } else {
                        RectanglePlusButton(cornerRadius: geometry.size.width * 0.025)
                            .tintColor(.yellow.opacity(0.8))
                            .foregroundStyle(.yellow)
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                    }
                })
                .sheet(isPresented: $isSelectingCenterOption) {
                    OptionSelectionView(options: options) { option in
                        selectedOptionCenter = option
                        isSelectingCenterOption.toggle()
                    }
                }
                
                Spacer()
                
                // Right Button
                Button(action: {
                    isSelectingRightOption.toggle()
                }, label: {
                    if let selectedView = selectedOptionRight?.view {
                        selectedView
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    } else {
                        RectanglePlusButton(cornerRadius: geometry.size.width * 0.025)
                            .tintColor(.yellow.opacity(0.3))
                            .foregroundStyle(.yellow)
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    }
                })
                .sheet(isPresented: $isSelectingRightOption) {
                    OptionSelectionView(options: options) { option in
                        selectedOptionRight = option
                        isSelectingRightOption.toggle()
                    }
                }
            }
            .padding(.horizontal, geometry.size.width * 0.05)
            .padding(.vertical, geometry.size.height * 0.05)
        }
        #if os(macOS)
        .buttonStyle(.plain)                // Removes macOS default button border/highlight
        .focusable(false)                  // Disables the focus ring on macOS
        #endif
    }
}

private struct OptionSelectionView: View {
    let options: [Option]
    let onSelect: (Option) -> Void
    
    var body: some View {
        NavigationView {
            List(options) { option in
                Button(action: {
                    onSelect(option)
                }) {
                    option.view
                        .frame(width: 30, height: 30)
                        .padding()
                }
                #if os(macOS)
                .buttonStyle(.plain)                // Removes macOS default button border/highlight
                .focusable(false)                  // Disables the focus ring on macOS
                #endif
            }
            .navigationTitle("Select Option")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}
