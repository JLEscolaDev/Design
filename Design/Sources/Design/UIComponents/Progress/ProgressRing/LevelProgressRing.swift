//
//  LevelProgressRing.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

public struct LevelProgressRing: View {
    public init (vm: LevelProgressViewModel) {
        self.vm = vm
    }
    
    @State private var vm: LevelProgressViewModel
    @State private var animateStrokeEnd = false
    
    public var body: some View {
        VStack(spacing: 20) {
            level
            
            graph
            .onAppear {
                self.animateStrokeEnd = true
            }
        }
    }
}

// - MARK: Subviews
extension LevelProgressRing {
    private var level: some View {
        Text("Nivel \(vm.level)")
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(Color(hex: "#FFD700"))
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private var progressText: some View {
        VStack {
            Text("\(Int(vm.progress * 100))%")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 10)
            Text("XP: \(Int(vm.currentXP))/\(Int(vm.requiredXP))")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    private var graph: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 20)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.animateStrokeEnd ? vm.progress : 0.0, 1.0)))
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [Color(hex: "#FFD700"), Color(hex: "#FF8C00"), Color(hex: "#FFD700")]), center: .center),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.5), value: animateStrokeEnd)
            
            progressText
        }
        .frame(width: 260, height: 260)
    }
}

extension LevelProgressRing {
    public static var preview: some View {
        LevelProgressRing(vm: .init(level: 20, currentXP: 1890, requiredXP: 2000))
    }
}

#Preview {
    LevelProgressRing.preview
}
