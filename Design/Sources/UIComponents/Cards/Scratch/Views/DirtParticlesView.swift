//
//  DirtParticlesView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 15/11/24.
//
import SwiftUI

struct DirtParticlesView: View {
    var dirtParticles: [DirtParticle]
    
    var body: some View {
        Canvas { context, size in
            for dirtParticle in dirtParticles {
                context.fill(dirtParticle.shape, with: .color(dirtParticle.color))
            }
        }
    }
}
