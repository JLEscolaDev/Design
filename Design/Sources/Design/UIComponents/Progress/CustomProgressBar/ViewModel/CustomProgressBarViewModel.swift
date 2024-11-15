//
//  CustomProgressBarViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/11/24.
//
import SwiftUI

@Observable
public class CustomProgressBarViewModel {
    var progress: CGFloat
    var backgroundGradient: Gradient
    var progressGradient: Gradient
    var milestoneIcons: [Image]
    var height: CGFloat
    var cornerRadius: CGFloat
    var animationDuration: Double
    var showPercentage: Bool
    var fontSize: CGFloat
    var textColor: Color
    var milestones: [CGFloat]
    var iconPadding: CGFloat
    var showAllIcons: Bool

    public init(
        progress: CGFloat = 0.5,
        backgroundGradient: Gradient = Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
        progressGradient: Gradient = Gradient(colors: [Color.blue, Color.purple]),
        milestoneIcons: [Image] = [Image(systemName: "star.fill"), Image(systemName: "crown.fill"), Image(systemName: "trophy.fill"), Image(systemName: "medal.fill")],
        height: CGFloat = 20,
        cornerRadius: CGFloat = 10,
        animationDuration: Double = 0.3,
        showPercentage: Bool = true,
        fontSize: CGFloat = 14,
        textColor: Color = Color.black,
        milestones: [CGFloat] = [0.25, 0.5, 0.75, 1.0],
        iconPadding: CGFloat = 8,
        showAllIcons: Bool = true
    ) {
        self.progress = progress
        self.backgroundGradient = backgroundGradient
        self.progressGradient = progressGradient
        self.milestoneIcons = milestoneIcons
        self.height = height
        self.cornerRadius = cornerRadius
        self.animationDuration = animationDuration
        self.showPercentage = showPercentage
        self.fontSize = fontSize
        self.textColor = textColor
        self.milestones = milestones
        self.iconPadding = iconPadding
        self.showAllIcons = showAllIcons
    }
}
