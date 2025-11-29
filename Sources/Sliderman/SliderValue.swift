//
//  SliderValue.swift
//  sliderman
//
//  Created by Єва Матвєєва on 27.11.2025.
//

/// Value type returned by the slider based on its mode
public enum SliderValue {

    /// Single value (default mode)
    case single(Float)

    /// Range value (range mode)
    case range(min: Float, max: Float)

    /// Marked value (marked mode) - includes both the actual value and the mark index
    case marked(value: Float, index: Int)

    // MARK: - Convenience Getters

    public var singleValue: Float? {
        if case .single(let value) = self { return value }
        if case .marked(let value, _) = self { return value }
        return nil
    }

    public var rangeValues: (min: Float, max: Float)? {
        if case .range(let min, let max) = self { return (min, max) }
        return nil
    }

    public var markedValue: (value: Float, index: Int)? {
        if case .marked(let value, let index) = self { return (value, index) }
        return nil
    }
}
