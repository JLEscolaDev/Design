//
//  InfoCardViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//

import SwiftUI

@Observable
public class InfoCardViewModel: Identifiable {
    public init(id: Int, image: Image, title: String? = nil, description: String? = nil, subtitle: String? = nil, style: InfoCard.InfoCardStyle) {
        self.id = id
        self.image = image
        self.title = title
        self.description = description
        self.subtitle = subtitle
        self.style = style
    }
    
    public var id: Int
    var image: Image
    var title: String?
    var description: String?
    var subtitle: String?
    var style: InfoCard.InfoCardStyle
}
