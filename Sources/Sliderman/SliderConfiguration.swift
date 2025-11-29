//
//  SliderConfiguration.swift
//  sliderman
//
//  Created by Єва Матвєєва on 23.11.2025.
//
import UIKit

/// Configuration for customizing slider appearance and behavior.
///
/// You can create a custom configuration or use pre-defined styles via `SliderStyle`.
public struct SliderConfiguration {
    
    // MARK: - Dimensions
    
    /// Height of the track in points. Default is `4`.
    public var trackHeight: CGFloat = 4
    
    /// Size of the thumb in points. Default is `28`.
    public var thumbSize: CGFloat = 28
    
    // MARK: - Colors
    
    /// Background color of the track. Default is `.gray`.
    public var trackColor: UIColor = .gray
    
    /// Progress color. Ignored if `progressGradient` is set. Default is `.systemBlue`.
    public var progressColor: UIColor? = .blue
    
    /// Gradient colors for progress. Takes priority over `progressColor`.
    ///
    /// Set to an array of colors to create a gradient effect:
    /// ```swift
    /// config.progressGradient = [.systemPink, .systemOrange, .systemYellow]
    /// ```
    public var progressGradient: [UIColor]? = nil
    
    /// Thumb color. Default is `.white`.
    public var thumbColor: UIColor = .white
    
    // MARK: - Visual Effects
    
    /// Whether the thumb should cast a shadow. Default is `true`.
    public var thumbShadow: Bool = true
    
    /// Whether the thumb should have a glow effect. Default is `false`.
    public var thumbGlow: Bool = false
    
    // MARK: - Behavior
    
    /// Animation duration for value changes in seconds. Default is `0.2`.
    public var animationDuration: TimeInterval = 0.2
    
    /// Haptic feedback mode. Default is `.light`.
    public var hapticMode: HapticMode = .light
    
    // MARK: - Initialization
    
    /// Creates a default configuration.
    public init(){}
}
