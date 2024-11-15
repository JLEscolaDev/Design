//
//  CustomProgressBarViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 2/11/24.
//


import SwiftUI
import AVFoundation

public struct CustomProgressBarView: View {
    @State var viewModel: CustomProgressBarViewModel

    @State private var player: AVAudioPlayer?
    @State private var showParticles: Bool = false

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    backgroundBar(width: geometry.size.width)
                    progressBar(width: geometry.size.width)
                    milestoneIcons(width: geometry.size.width)
                }
                .gesture(DragGesture().onEnded { value in
                    let newProgress = value.location.x / geometry.size.width
                    viewModel.progress = min(max(newProgress, 0.0), 1.0)
                })
                .overlay(
                    showParticles ? ParticleEffectView().offset(x: viewModel.progress * geometry.size.width - viewModel.height / 2) : nil
                )
            }
            .frame(height: viewModel.height)

            if viewModel.showPercentage {
                progressText
            }
        }
        .padding()
        .onChange(of: viewModel.progress) { newValue in
            handleMilestoneReached(newValue)
        }
    }
}

// MARK: - Subviews

extension CustomProgressBarView {
    private func backgroundBar(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: viewModel.cornerRadius)
            .fill(LinearGradient(gradient: viewModel.backgroundGradient, startPoint: .leading, endPoint: .trailing))
            .frame(width: width, height: viewModel.height)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }

    private func progressBar(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: viewModel.cornerRadius)
            .fill(LinearGradient(gradient: viewModel.progressGradient, startPoint: .leading, endPoint: .trailing))
            .frame(width: viewModel.progress * width, height: viewModel.height)
            .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
            .animation(.easeInOut(duration: viewModel.animationDuration), value: viewModel.progress)
    }

    private func milestoneIcons(width: CGFloat) -> some View {
            ForEach(Array(viewModel.milestones.enumerated()), id: \.offset) { index, milestone in
                let iconOffset = adjustedOffset(milestone: milestone, width: width)
                let isReached = milestone <= viewModel.progress
                let showIcon = isReached || viewModel.showAllIcons
                
                ZStack {
                    if isReached {
                        Image(.handDrawnCircle)
                            .resizable()
                            .frame(width: viewModel.height + 10, height: viewModel.height + 10)
                    }
                    viewModel.milestoneIcons[index % viewModel.milestoneIcons.count]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: viewModel.height, height: viewModel.height)
                        .opacity(showIcon ? (isReached ? 1.0 : 0.15) : 0.0) // Aplicar opacidad solo si showAllIcons está activado
                }
                .offset(x: iconOffset)
                .transition(.scale)
                .animation(.easeInOut(duration: viewModel.animationDuration), value: viewModel.progress)
            }
        }

    private func adjustedOffset(milestone: CGFloat, width: CGFloat) -> CGFloat {
        let baseOffset = milestone * width - viewModel.height / 2
        let padding = viewModel.iconPadding
        let epsilon: CGFloat = 0.01
        if abs(milestone - 0.0) < epsilon {
            // Ajuste para el primer hito
            return padding
        } else if abs(milestone - 1.0) < epsilon {
            // Ajuste para el último hito
            return width - viewModel.height - padding
        } else {
            return baseOffset
        }
    }

    private var progressText: some View {
        HStack {
            Text(progressMessage())
                .font(.system(size: viewModel.fontSize))
                .foregroundColor(viewModel.textColor)
            Spacer()
        }
    }
}

// MARK: - Helper Functions
    
extension CustomProgressBarView {
    private func progressMessage() -> String {
        switch viewModel.progress {
        case 0..<0.25:
            return "¡Acabas de empezar!"
        case 0.25..<0.5:
            return "¡Buen trabajo, sigue así!"
        case 0.5..<0.75:
            return "¡Estás a la mitad del camino!"
        case 0.75..<1.0:
            return "¡Casi llegas!"
        default:
            return "¡Meta alcanzada, felicidades!"
        }
    }

    private func handleMilestoneReached(_ progress: CGFloat) {
        for milestone in viewModel.milestones {
            if abs(progress - milestone) < 0.01 {
                playSuccessSound()
                showParticles = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showParticles = false
                }
                return
            }
        }
    }

    private func playSuccessSound() {
        let soundFileName = "sucessSoundEffect"
        
        if let url = Bundle.module.url(forResource: soundFileName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("Error: reproducing success sound (fileName: \(soundFileName)): \(error.localizedDescription)")
            }
        } else {
            print("Error: Sound couldn't be found")
        }
    }
}


// MARK: - Preview

public extension CustomProgressBarView {
    static var preview: some View {
        VStack(spacing: 30) {
            CustomProgressBarView(viewModel: CustomProgressBarViewModel(progress: 0.0, milestones: [0.0, 0.25, 0.5, 0.75, 1.0]))
                .frame(width: 300)
            CustomProgressBarView(viewModel: CustomProgressBarViewModel(progress: 0.1))
                .frame(width: 300)
            CustomProgressBarView(viewModel: CustomProgressBarViewModel(progress: 0.5, progressGradient: Gradient(colors: [Color.green, Color.yellow])))
                .frame(width: 300)
            
            CustomProgressBarView(viewModel: CustomProgressBarViewModel(progress: 0.8, showPercentage: false))
                .frame(width: 300)
            CustomProgressBarView(viewModel: CustomProgressBarViewModel(progress: 1.0, milestones: [0.0, 0.25, 0.5, 0.75, 1.0]))
                .frame(width: 300)
                .foregroundStyle(.white)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    CustomProgressBarView.preview
}
