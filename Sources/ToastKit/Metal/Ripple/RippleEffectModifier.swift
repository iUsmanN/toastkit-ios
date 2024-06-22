//
//  RippleEffectModifier.swift
//  SiriAnimationPrototype
//
//  From Video: https://developer.apple.com/videos/play/wwdc2024/10151/?time=1416
//

import SwiftUI

/// A modifer that performs a ripple effect to its content whenever its
/// trigger value changes.
@available(iOS 17.0, *)
public struct ToastKitRippleEffect: ViewModifier {
    var origin: CGPoint
    var trigger: Bool
    
    public init(at origin: CGPoint) {
        self.origin = origin
        self.trigger = ToastKit.shared.rippleTrigger
    }
    
    public init() {
        let centered: Bool = ToastKit.shared.model.isCentered
        if centered {
            self.origin = .init(x: (UIScreen.current?.bounds.width ?? 0)/2, y: (UIScreen.current?.bounds.height ?? 0)/2)
        } else {
            self.origin = .init(x: (UIScreen.current?.bounds.width ?? 0)/2, y: 10)
        }
        self.trigger = ToastKit.shared.rippleTrigger
    }

    public func body(content: Content) -> some View {
        let origin = origin
        let duration = duration

        content.keyframeAnimator(
            initialValue: 0,
            trigger: trigger
        ) { view, elapsedTime in
            view.modifier(RippleModifier(
                origin: origin,
                elapsedTime: elapsedTime,
                duration: duration
            ))
        } keyframes: { _ in
            MoveKeyframe(0)
            LinearKeyframe(duration, duration: duration)
        }
    }

    var duration: TimeInterval { 3 }
}

/// A modifier that applies a ripple effect to its content.
@available(iOS 17.0, *)
struct RippleModifier: ViewModifier {
    var origin: CGPoint

    var elapsedTime: TimeInterval

    var duration: TimeInterval

    var amplitude: Double = ToastKit.shared.model.isCentered ? 15 : 25
    var frequency: Double = 15
    var decay: Double = 45
    var speed: Double = 1500

    func body(content: Content) -> some View {
        let shader = ShaderLibrary.Ripple(
            .float2(origin),
            .float(elapsedTime),

            // Parameters
            .float(amplitude),
            .float(frequency),
            .float(decay),
            .float(speed)
        )

        let maxSampleOffset = maxSampleOffset
        let elapsedTime = elapsedTime
        let duration = duration

        content.visualEffect { view, _ in
            view.layerEffect(
                shader,
                maxSampleOffset: maxSampleOffset,
                isEnabled: 0 < elapsedTime && elapsedTime < duration
            )
        }
    }

    var maxSampleOffset: CGSize {
        CGSize(width: amplitude, height: amplitude)
    }
}
