//
//  NotchModifier.swift
//  Design
//
//  Created by Jose Luis Escolá García on 29/11/24.
//

import SwiftUI

public struct NotchModifier: ViewModifier {
    let vm: NotchModifierModel
    
    public init(vm: NotchModifierModel) {
        self.vm = vm
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .clipShape(NotchedShape(deformation: vm.deformationAmount, notchLengthMultiplier: vm.notchLengthMultiplier, notchPosition: vm.notchPosition, side: vm.notchSide))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            vm.processDrag(gesture: gesture, geometry: geometry)
                        }
                        .onEnded { _ in
                            vm.resetNotch()
                        }
                )
                .animation(.spring(response: 0.3, dampingFraction: vm.dampingFraction), value: vm.deformationAmount)
                .onAppear {
                    vm.notchPosition = geometry.size.height/2
                }
        }
    }
}

// - MARK: Preview
extension NotchModifier {
    public static var preview: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.all)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .withNotch(
                    allowedSides: [.all],
                    notchFollowsTouch: true,
                    invertNotchDisplay: false
                )
                .frame(width: 300, height: 300)
        }
    }
}


#Preview {
    NotchModifier.preview
}
