//
//  BouncyTabBarShapeWithSelectorCurve.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 5/6/24.
//

import SwiftUI

/// A custom shape for the BouncyTabBar with a selector curve.
struct BouncyTabBarShapeWithSelectorCurve: Shape {
    var xAxis: CGFloat
    var curveAmount: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(xAxis, curveAmount) }
        set {
            xAxis = newValue.first
            curveAmount = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            if curveAmount > 0 {
                let center = xAxis + 15
                
                path.move(to: CGPoint(x: center - 50, y: 0))
                
                let to1 = CGPoint(x: center, y: 55 * curveAmount)
                let control1 = CGPoint(x: center - 25, y: 0)
                let control2 = CGPoint(x: center - 25, y: 55 * curveAmount)
                
                let to2 = CGPoint(x: center + 50, y: 0)
                let control3 = CGPoint(x: center + 25, y: 55 * curveAmount)
                let control4 = CGPoint(x: center + 25, y: 0)
                
                path.addCurve(to: to1, control1: control1, control2: control2)
                path.addCurve(to: to2, control1: control3, control2: control4)
            }
        }
    }
}
