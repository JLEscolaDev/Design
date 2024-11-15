//
//  EdgeInsets.swift
//  Design
//
//  Created by Jose Luis Escolá García on 11/11/24.
//
import SwiftUI

extension EdgeInsets {
    init(all metric: CGFloat) {
        self.init(
            top: metric,
            leading: metric,
            bottom: metric,
            trailing: metric
        )
    }
}
