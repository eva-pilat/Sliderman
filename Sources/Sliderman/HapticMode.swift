//
//  HapticMode.swift
//  sliderman
//
//  Created by Єва Матвєєва on 23.11.2025.
//

import UIKit

/// Haptic feedback modes for slider interaction
public enum HapticMode {
    
    /// No haptic feedback
    case disabled
    
    /// Light haptic on tap/drag start only
    case light
    
    /// Medium haptic on tap/drag start only
    case medium
    
    /// Heavy haptic on tap/drag start only
    case heavy
    
    /// Light haptic + feedback every 10% while dragging
    case lightContinuous
    
    /// Medium haptic + feedback every 10% while dragging
    case mediumContinuous
    
    /// Heavy haptic + feedback every 10% while dragging
    case heavyContinuous
    
    /// Light haptic + feedback every 5% while dragging
    case lightWithSteps
    
    /// Medium haptic + feedback every 5% while dragging
    case mediumWithSteps
    
    /// Haptic feedback only at 0% and 100%
    case edgesOnly
    
    // MARK: - Internal Properties
    
    var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .disabled:
            return .light
        case .light, .lightContinuous, .lightWithSteps:
            return .light
        case .medium, .mediumContinuous, .mediumWithSteps:
            return .medium
        case .heavy, .heavyContinuous:
            return .heavy
        case .edgesOnly:
            return .rigid
        }
    }
    
    var isContinuous: Bool {
        switch self {
        case .lightContinuous, .mediumContinuous, .heavyContinuous, .lightWithSteps, .mediumWithSteps:
            return true
        default:
            return false
        }
    }
    
    var hapticStep: Float {
        switch self{
            
        case .lightWithSteps, .mediumWithSteps:
            return 0.05
            
        case .lightContinuous, .mediumContinuous, .heavyContinuous:
            return 0.1
            
        default:
            return 1.0
            
        }
    }
    
    var isEnabled: Bool {
        return self != .disabled
    }
}
