//
//  DragState.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//
import SwiftUI

public enum DragState {
    case inactive
    case dragging/*(translation: CGSize)*/
    
//    var translation: CGSize {
//        switch self {
//        case .inactive:
//            return .zero
//        case .dragging(let translation):
//            return translation
//        }
//    }
    
    var isDragging: Bool {
        self == .dragging ? true : false
    }
}
