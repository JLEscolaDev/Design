//
//  File.swift
//  Design
//
//  Created by Jose Luis Escolá García on 29/11/24.
//

import SwiftUI

extension NotchSides {
    var inverted: Self {
        switch self {
            case .left:
                .right
            case .right:
                .left
            case .top:
                .bottom
            case .bottom:
                .top
            default:
                .all
        }
    }
}
