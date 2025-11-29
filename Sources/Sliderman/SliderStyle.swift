//
//  SliderStyle.swift
//  sliderman
//
//  Created by Єва Матвєєва on 23.11.2025.
//

import UIKit

/// Pre-defined slider styles for quick customization
public enum SliderStyle {

    /// Default iOS-style slider
    case `default`

    /// Native iOS slider appearance
    case iOS

    /// Vibrant pink style
    case vibrant

    /// Minimal black and white
    case minimal

    /// Colorful neon gradient
    case neon

    /// Sunset gradient (yellow to red)
    case sunset

    /// Ocean gradient (cyan to indigo)
    case ocean

    /// Purple gradient
    case grape

    /// Mint to teal gradient
    case mint

    /// Custom configuration
    case custom(SliderConfiguration)

    // MARK: - Configuration

    public var configuration: SliderConfiguration {
        switch self {
        case .default:
            return SliderConfiguration()

        case .iOS:
            var config = SliderConfiguration()
            config.trackHeight = 4
            config.thumbSize = 28
            config.trackColor = .systemGray5
            config.progressColor = .systemBlue
            config.thumbColor = .white
            config.thumbShadow = true
            config.hapticMode = .light
            return config

        case .vibrant:
            var config = SliderConfiguration()
            config.trackHeight = 12
            config.thumbSize = 36
            config.trackColor = UIColor.systemPink.withAlphaComponent(0.2)
            config.progressColor = .systemPink
            config.thumbColor = .white
            config.thumbShadow = true
            config.hapticMode = .medium
            config.animationDuration = 0.25
            return config

        case .minimal:
            var config = SliderConfiguration()
            config.trackHeight = 2
            config.thumbSize = 20
            config.trackColor = .systemGray6
            config.progressColor = .label
            config.thumbColor = .label
            config.thumbShadow = false
            config.hapticMode = .disabled
            config.animationDuration = 0.15
            return config

        case .neon:
            var config = SliderConfiguration()
            config.trackHeight = 12
            config.thumbSize = 32
            config.trackColor = UIColor.systemPurple.withAlphaComponent(0.15)
            config.progressGradient = [
                UIColor.systemPurple,
                UIColor.systemPink,
                UIColor.systemOrange
            ]
            config.thumbColor = .white
            config.thumbShadow = true
            config.thumbGlow = true
            config.hapticMode = .heavy
            return config

        case .sunset:
            var config = SliderConfiguration()
            config.trackHeight = 12
            config.thumbSize = 38
            config.trackColor = UIColor.systemOrange.withAlphaComponent(0.2)
            config.progressGradient = [
                UIColor.systemYellow,
                UIColor.systemOrange,
                UIColor.systemRed
            ]
            config.thumbColor = .white
            config.thumbShadow = true
            config.hapticMode = .mediumWithSteps
            return config

        case .ocean:
            var config = SliderConfiguration()
            config.trackHeight = 12
            config.thumbSize = 34
            config.trackColor = UIColor.systemTeal.withAlphaComponent(0.15)
            config.progressGradient = [
                UIColor.systemCyan,
                UIColor.systemBlue,
                UIColor.systemIndigo
            ]
            config.thumbColor = .white
            config.thumbShadow = true
            config.hapticMode = .lightContinuous
            return config

        case .grape:
            var config = SliderConfiguration()
            config.trackHeight = 12
            config.thumbSize = 32
            config.trackColor = UIColor.systemPurple.withAlphaComponent(0.2)
            config.progressGradient = [
                UIColor.systemPurple,
                UIColor.systemIndigo
            ]
            config.thumbColor = .white
            config.thumbShadow = true
            config.hapticMode = .medium
            return config

        case .mint:
            var config = SliderConfiguration()
            config.trackHeight = 20
            config.thumbSize = 36
            config.trackColor = UIColor.systemMint.withAlphaComponent(0.15)
            config.progressGradient = [
                UIColor.systemMint,
                UIColor.systemTeal
            ]
            config.thumbColor = .white
            config.thumbShadow = true
            config.hapticMode = .light
            return config

        case .custom(let config):
            return config
        }
    }
}
