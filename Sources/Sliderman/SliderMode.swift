//
//  SliderMode.swift
//  sliderman
//
//  Created by Єва Матвєєва on 27.11.2025.
//

import UIKit

/// Operating modes for the slider
public enum SliderMode {

    /// Standard single-value slider
    case `default`

    /// Range slider with two thumbs for min/max selection
    case range

    /// Slider with discrete marked positions that thumb snaps to
    /// - Parameter count: Number of marks (positions) on the slider
    case marked(count: Int)

    // MARK: - Convenience

    var isRange: Bool {
        if case .range = self { return true }
        return false
    }

    var isMarked: Bool {
        if case .marked = self { return true }
        return false
    }

    var markCount: Int {
        if case .marked(let count) = self { return count }
        return 0
    }
}
