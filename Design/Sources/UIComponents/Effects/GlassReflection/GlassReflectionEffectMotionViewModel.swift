//
//  GlassReflectionEffectMotionViewModel.swift
//  Design
//
//  Created by Jose Luis Escolá García on 7/11/24.
//
#if os(iOS)
import SwiftUI
import CoreMotion

@Observable
final class GlassReflectionEffectMotionViewModel {
    
    /// Sensor movement value to controll how much the device has moved from its initial position
    var roll: Double = 0.0
    
    /// Motion manager
    @ObservationIgnored private var manager: CMMotionManager


    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 10/60

        self.manager.startDeviceMotionUpdates(to: .main) { [weak self] motionData, error in
            guard let self = self else { return }

            if let error = error {
                print(error)
                return
            }

            if let motionData = motionData {
                self.roll = motionData.attitude.roll
            }
        }
    }

    deinit {
        self.manager.stopDeviceMotionUpdates()
    }
    
    /// Retrieves the next LinearGradient to be displayed
    @ObservationIgnored var glassEffect: LinearGradient {
        switch roll {
            case ..<(-1.5):
                LinearGradient(gradient: Gradient(colors: [
                    .white.opacity(0.3),
                    .clear,
                    .clear,
                    .clear,
                    .clear
                ]), startPoint: .leading, endPoint: .trailing)
                
            case -1.5 ..< -0.9 :
                LinearGradient(gradient: Gradient(colors: [
                    .clear,
                    .white.opacity(0.1),
                    .white.opacity(0.3),
                    .clear,
                    .clear
                ]), startPoint: .leading, endPoint: .trailing)
                
            case -0.9 ..< -0.4 :
                LinearGradient(gradient: Gradient(colors: [
                    .clear,
                    .clear,
                    .white.opacity(0.1),
                    .white.opacity(0.3),
                    .clear
                ]), startPoint: .leading, endPoint: .trailing)
                
            case -0.4 ..< -0.2 :
                LinearGradient(gradient: Gradient(colors: [
                    .clear,
                    .clear,
                    .clear,
                    .white.opacity(0.2),
                    .white.opacity(0.1)
                ]), startPoint: .leading, endPoint: .trailing)
                
            case -0.2 ..< 0.2:
                LinearGradient(gradient: Gradient(colors: [
                    .white.opacity(0.3),
                    .clear,
                    .clear,
                    .clear,
                    .white.opacity(0.3)
                ]), startPoint: .leading, endPoint: .trailing)
                
            case 0.2 ..< 0.4 :
                LinearGradient(gradient: Gradient(colors: [
                    .white.opacity(0.1),
                    .white.opacity(0.2),
                    .clear,
                    .clear,
                    .clear
                ]), startPoint: .leading, endPoint: .trailing)
                
            case 0.4 ..< 0.9 :
                LinearGradient(gradient: Gradient(colors: [
                    .clear,
                    .white.opacity(0.3),
                    .white.opacity(0.1),
                    .clear,
                    .clear
                ]), startPoint: .leading, endPoint: .trailing)
                
            case 0.9 ..< 1.5 :
                LinearGradient(gradient: Gradient(colors: [
                    .clear,
                    .clear,
                    .white.opacity(0.3),
                    .white.opacity(0.1),
                    .clear
                ]), startPoint: .leading, endPoint: .trailing)
                
            case 1.5... :
                LinearGradient(gradient: Gradient(colors: [
                    .clear,
                    .clear,
                    .clear,
                    .clear,
                    .white.opacity(0.3)
                ]), startPoint: .leading, endPoint: .trailing)
                
            default:
                LinearGradient(gradient: Gradient(colors: [
                    .white.opacity(0.3),
                    .clear,
                    .clear,
                    .clear,
                    .white.opacity(0.3)
                ]), startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    @Previewable @State var coreMotionVM = GlassReflectionEffectMotionViewModel()
    
    return RoundedRectangle(cornerRadius: 25).fill(.black).overlay {
        coreMotionVM.glassEffect
            .animation(
                .easeInOut,
                value: coreMotionVM.roll
            )
    }.frame(width: 200, height: 200)
}
#endif
