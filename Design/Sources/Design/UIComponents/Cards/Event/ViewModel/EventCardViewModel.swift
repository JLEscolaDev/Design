//
//  EventCardViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 30/10/24.
//

import SwiftUI

@Observable
class EventCardViewModel {
    let title: String
    let location: String?
    let startDate: String?
    let endDate: String?
    var imageLoader: ImageLoader
    
    init(title: String, location: String?, startDate: String?, endDate: String?, imageLoader: ImageLoader) {
        self.title = title
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.imageLoader = imageLoader
        self.imageLoader.load()
    }
}
