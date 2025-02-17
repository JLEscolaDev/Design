//
//  AnimationModel.swift
//  testSwiftui
//
//  Created by Jose Luis Escolá García on 7/5/24.
//

import SwiftUI
import AVFoundation

@Observable
class AnimationModel {
    enum sizes {
        static let minLiquidHeight: CGFloat = 15
        static let mediumLiquidHeight: CGFloat = 75
        static let maxLiquidHeight: CGFloat = 150
    }
    enum AnimationState {
        case FULL, MID_FULL, EMPTY
    }
    
    var animationState: AnimationState = .FULL
    @ObservationIgnored var liquidSpeed: Double = 6
    var liquidAmplitude: Double = 0
    var animationProgress: Double = 0.0
    var frameHeight: CGFloat = sizes.maxLiquidHeight
    @ObservationIgnored var previousFrameHeight: CGFloat = sizes.maxLiquidHeight

    private let duration: TimeInterval = 1.75
    private let animationFrames: Int = 60
    @ObservationIgnored private var currentFrame: Int = 0
    @ObservationIgnored private var timer: Timer?
    @ObservationIgnored private var previousAnimationState: AnimationState = .EMPTY
    @ObservationIgnored private var audioPlayer: AVAudioPlayer?

    @ObservationIgnored private var frameDuration: TimeInterval {
        duration / Double(animationFrames)
    }

    init() {
        previousAnimationState = animationState
    }
    
    deinit {
        stopAnimation()
    }

    func toggleAnimation() {
        stopAnimation()

        DispatchQueue.main.asyncAfter(deadline: .now() + frameDuration) { [weak self] in
            guard let self else { return }
            self.calculateNextAnimationState()
            self.startAnimation()
            self.stopAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + self.frameDuration) {
                self.calculateNextAnimationState()
                self.startAnimation()
            }
        }
    }

    private func calculateNextAnimationState() {
        var newAnimationState = AnimationState.FULL
        let newPreviousAnimationState = animationState
        switch animationState {
        case .FULL, .EMPTY:
            newAnimationState = .MID_FULL
        case .MID_FULL:
            if previousAnimationState == .EMPTY {
                newAnimationState = .FULL
            } else {
                newAnimationState = .EMPTY
            }
        }
        previousAnimationState = newPreviousAnimationState
        animationState = newAnimationState

        // Reproducir sonido si el estado anterior era FULL o EMPTY
        if previousAnimationState == .FULL || previousAnimationState == .EMPTY {
            playRandomSound()
        }
    }

    private func playRandomSound() {
        // Lista de nombres de archivos de sonido
        let soundFileNames = ["ice-liquid-1", "ice-liquid-2", "ice-liquid-3"]
        
        // Seleccionar un nombre de archivo aleatorio
        if let randomFileName = soundFileNames.randomElement(),
           let url = Bundle.module.url(forResource: randomFileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error: reproducing sound \(randomFileName): \(error.localizedDescription)")
            }
        } else {
            print("Error: Sound couldn't be found")
        }
    }

    func startAnimation() {
        currentFrame = 0
        previousFrameHeight = frameHeight
        
        withAnimation(.easeInOut(duration: 1.75)) {
            switch animationState {
                case .FULL:
                    liquidAmplitude = 0.0
                    frameHeight = sizes.maxLiquidHeight
                case .MID_FULL:
                    liquidAmplitude = 5.0
                    frameHeight = sizes.mediumLiquidHeight
                case .EMPTY:
                    liquidAmplitude = 0.0
                    frameHeight = sizes.minLiquidHeight
            }
        }
        

        timer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { [weak self] timer in
            guard let self else { return }
            // Animar transición si no es la primera vez que aparece la vista
            if !(self.animationState == .FULL && self.previousAnimationState == .FULL) {
                self.updateAnimation()
            }
        }
    }

    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }

    private func updateAnimation() {
        let progress = Double(currentFrame) / Double(animationFrames)
        
        switch animationState {
        case .FULL:
            animationProgress = 1.0 - progress
        case .MID_FULL:
            animationProgress = progress
        case .EMPTY:
            animationProgress = 1.0 - progress
        }
        
        liquidAmplitude = sin(animationProgress * .pi / 2.0) * 10.0
        
        currentFrame += 1
        
        if currentFrame > animationFrames {
            stopAnimation()
        }
    }
}
