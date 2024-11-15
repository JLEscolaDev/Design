//
//  LevelProgressViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

@Observable
public class LevelProgressViewModel {
    var level: Int
    var currentXP: Double
    var requiredXP: Double
    
    var progress: Double {
        return currentXP / requiredXP
    }
    
    public init(level: Int, currentXP: Double, requiredXP: Double) {
        self.level = level
        self.currentXP = currentXP
        self.requiredXP = requiredXP
    }
}
