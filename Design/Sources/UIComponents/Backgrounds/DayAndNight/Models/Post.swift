//
//  Post.swift
//  Design
//
//  Created by Jose Luis Escolá García on 6/11/24.
//
import SwiftUI

public struct Post : Identifiable {
    public var id = UUID()
    var subtitle : String
    var title : String
    var extra : String
    var showDetails: Bool = false // We need this variable to control each cell individually
}
