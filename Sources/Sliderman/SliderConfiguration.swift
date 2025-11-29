//
//  SliderConfiguration.swift
//  sliderman
//
//  Created by Єва Матвєєва on 23.11.2025.
//
import UIKit

public struct SliderConfiguration {
    
    // MARK: - Dimensions
    
    public var trackHeight: CGFloat = 4
    
    public var thumbSize: CGFloat = 28
    
    // MARK: - Colors
    
    public var trackColor: UIColor = .gray
    
    public var progressColor: UIColor? = .blue
    
    public var progressGradient: [UIColor]? = nil
    
    public var thumbColor: UIColor = .white
    
    // MARK: - Visual Effects
    
    public var thumbShadow: Bool = true
    
    public var thumbGlow: Bool = false
    
    // MARK: - Behavior
    
    public var animationDuration: TimeInterval = 0.2
    
    public var hapticMode: HapticMode = .light
    
    // MARK: - Initialization
    
    public init(){}
}
