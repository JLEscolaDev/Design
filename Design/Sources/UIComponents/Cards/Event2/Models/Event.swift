//
//  Event.swift
//  Design
//
//  Created by Jose Luis Escolá García on 5/11/24.
//
import SwiftUI

public struct Event: Identifiable, Codable {
    public var id = UUID()
    let name: String
    let date: Date
}
