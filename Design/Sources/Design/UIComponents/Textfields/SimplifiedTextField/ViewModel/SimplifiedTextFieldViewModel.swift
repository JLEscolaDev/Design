//
//  SimplifiedTextFieldViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 4/11/24.
//

import SwiftUI

@Observable
class SimplifiedTextFieldViewModel {
    var placeholder: String
    var text: String = ""
    var isSecure: Bool = false
    var backgroundColor: Color = .white
    var textColor: Color = .black
    var borderColor: Color = .gray
    var borderRadius: CGFloat = 10
    var fontSize: CGFloat = 16
    var padding: CGFloat = 15
    var shadowColor: Color = .black
    var shadowRadius: CGFloat = 5
    var shadowOpacity: Double = 0.1
    
    init(
        placeholder: String,
        text: String = "",
        isSecure: Bool = false,
        backgroundColor: Color = .white,
        textColor: Color = .black,
        borderColor: Color = .gray,
        borderRadius: CGFloat = 10,
        fontSize: CGFloat = 16,
        padding: CGFloat = 15,
        shadowColor: Color = .black,
        shadowRadius: CGFloat = 5,
        shadowOpacity: Double = 0.1
    ) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.borderRadius = borderRadius
        self.fontSize = fontSize
        self.padding = padding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
    }
}
