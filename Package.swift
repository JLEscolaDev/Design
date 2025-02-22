// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Package.swift
import PackageDescription

let package = Package(
    name: "Design",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Design",
            targets: ["Design"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Design",
            dependencies: [],
            path: "Design/Sources",
            resources: [
                .process("Resources/Assets.xcassets"),
                .process("Resources/ice-liquid-1.mp3"),
                .process("Resources/ice-liquid-2.mp3"),
                .process("Resources/ice-liquid-3.mp3"),
                .process("Resources/sucessSoundEffect.mp3"),
            ]
        ),
        .testTarget(
            name: "DesignTests",
            dependencies: ["Design"],
            path: "Design/Tests"
        ),
    ]
)
