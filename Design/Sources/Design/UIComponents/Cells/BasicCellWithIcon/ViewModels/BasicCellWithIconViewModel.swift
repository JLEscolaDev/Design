//
//  BasicCellWithIconViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 30/10/24.
//

import SwiftUI

struct BasicCellWithIconViewModel {
    let icon: Image?
    let iconColor: Color?
    let title: String
    let text: String
    let textColor: Color?
    
    init(icon: Image? = nil, iconColor: Color? = nil, title: String, text: String, textColor: Color? = nil) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.text = text
        self.textColor = textColor
    }
}
