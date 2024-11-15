//
//  SectionItem.swift
//  DesignApp
//
//  Created by Jose Luis Escolá García on 30/10/24.
//
import SwiftUI

struct SectionItem: Identifiable {
    let id = UUID()
    let title: String
    let destinationView: AnyView
}
