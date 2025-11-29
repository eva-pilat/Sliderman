//
//  Untitled.swift
//  sliderman
//
//  Created by Єва Матвєєва on 18.11.2025.
//
import UIKit

/// A customizable slider control with multiple operating modes
open class CustomSlider: UIControl {
    
    // MARK: - Public Properties
    
    /// Minimum value (default: 0)
    public var minimumValue: Float = 0 {
        didSet { updateValues() }
    }
    
    /// Maximum value (default: 1)
    public var maximumValue: Float = 1 {
        didSet { updateValues() }
    }
    
    /// Current slider value (type depends on mode)
    public var sliderValue: SliderValue = .single(0.5) {
        didSet {
            updateThumbPositions(animated: false)
            sendActions(for: .valueChanged)
        }
    }
    
    /// Operating mode of the slider
    public var mode: SliderMode = .default {
        didSet {
            if mode.isRange != oldValue.isRange || mode.isMarked != oldValue.isMarked {
                setupForMode()
            }
        }
    }
    
    /// Configuration for customizing appearance and behavior
    public var configuration: SliderConfiguration = SliderConfiguration() {
        didSet { applyConfiguration() }
    }
    
    // MARK: - Convenience Properties (for backward compatibility)
    
    /// Single value - works only in .default and .marked modes
    public var value: Float {
        get {
            return sliderValue.singleValue ?? 0.5
        }
        set {
            if case .range = mode { return }
            if case .marked(let count) = mode {
                let markIndex = findNearestMarkIndex(for: newValue, totalMarks: count)
                let markValue = valueForMarkIndex(markIndex, totalMarks: count)
                sliderValue = .marked(value: markValue, index: markIndex)
            } else {
                sliderValue = .single(clampValue(newValue))
            }
        }
    }
    
    /// Range values - works only in .range mode
    public var rangeValues: (min: Float, max: Float) {
        get {
            return sliderValue.rangeValues ?? (minimumValue, maximumValue)
        }
        set {
            guard case .range = mode else { return }
            let min = clampValue(newValue.min)
            let max = clampValue(newValue.max)
            sliderValue = .range(min: min, max: max)
        }
    }
    
    // MARK: - Private Properties
    
    private let trackView = UIView()
    private let progressView = UIView()
    private var gradientLayer: CAGradientLayer?
    
    // Thumbs
    private let thumbView = UIView()
    private let secondThumbView = UIView() // For range mode
    private var activeThumb: UIView?
    
    // Marks
    private var markViews: [UIView] = []
    
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    // Constraints
    private var thumbCenterXConstraint: NSLayoutConstraint?
    private var secondThumbCenterXConstraint: NSLayoutConstraint?
    private var trackHeightConstraint: NSLayoutConstraint?
    private var thumbWidthConstraint: NSLayoutConstraint?
    private var thumbHeightConstraint: NSLayoutConstraint?
    private var secondThumbWidthConstraint: NSLayoutConstraint?
    private var secondThumbHeightConstraint: NSLayoutConstraint?
    private var trackLeadingConstraint: NSLayoutConstraint?
    private var trackTrailingConstraint: NSLayoutConstraint?
    private var progressHeightConstraint: NSLayoutConstraint?
    private var progressLeadingConstraint: NSLayoutConstraint?
    
    private var isTrackingg = false
    private var lastHapticValue: Float = 0
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestures()
        applyConfiguration()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGestures()
        applyConfiguration()
    }
    
    // MARK: - Public Methods
    
    /// Apply a pre-defined style to the slider
    public func setStyle(_ style: SliderStyle) {
        self.configuration = style.configuration
    }
    
    /// Change the operating mode of the slider
    public func setMode(_ mode: SliderMode) {
        self.mode = mode
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        // Track
        trackView.translatesAutoresizingMaskIntoConstraints = false
        trackView.isUserInteractionEnabled = false
        addSubview(trackView)
        
        // Progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.isUserInteractionEnabled = false
        addSubview(progressView)
        
        // Primary thumb
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.isUserInteractionEnabled = false
        addSubview(thumbView)
        
        // Secondary thumb (hidden by default)
        secondThumbView.translatesAutoresizingMaskIntoConstraints = false
        secondThumbView.isUserInteractionEnabled = false
        secondThumbView.isHidden = true
        addSubview(secondThumbView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let trackHeight = configuration.trackHeight
        let thumbSize = configuration.thumbSize
        
        trackLeadingConstraint = trackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: thumbSize / 2)
        trackTrailingConstraint = trackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -thumbSize / 2)
        trackHeightConstraint = trackView.heightAnchor.constraint(equalToConstant: trackHeight)
        
        progressHeightConstraint = progressView.heightAnchor.constraint(equalToConstant: trackHeight)
        progressLeadingConstraint = progressView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor)
        
        thumbWidthConstraint = thumbView.widthAnchor.constraint(equalToConstant: thumbSize)
        thumbHeightConstraint = thumbView.heightAnchor.constraint(equalToConstant: thumbSize)
        
        secondThumbWidthConstraint = secondThumbView.widthAnchor.constraint(equalToConstant: thumbSize)
        secondThumbHeightConstraint = secondThumbView.heightAnchor.constraint(equalToConstant: thumbSize)
        
        NSLayoutConstraint.activate([
            // Track
            trackLeadingConstraint!,
            trackTrailingConstraint!,
            trackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trackHeightConstraint!,
            
            // Progress
            progressLeadingConstraint!,
            progressView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            progressHeightConstraint!,
            progressView.trailingAnchor.constraint(equalTo: thumbView.centerXAnchor),
            
            // Primary thumb
            thumbView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbWidthConstraint!,
            thumbHeightConstraint!,
            
            // Secondary thumb
            secondThumbView.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondThumbWidthConstraint!,
            secondThumbHeightConstraint!
        ])
        
        thumbCenterXConstraint = thumbView.centerXAnchor.constraint(
            equalTo: leadingAnchor,
            constant: thumbSize / 2
        )
        thumbCenterXConstraint?.isActive = true
        
        secondThumbCenterXConstraint = secondThumbView.centerXAnchor.constraint(
            equalTo: leadingAnchor,
            constant: thumbSize / 2
        )
        secondThumbCenterXConstraint?.isActive = true
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupForMode() {
        switch mode {
        case .default:
            secondThumbView.isHidden = true
            removeMarks()
            progressLeadingConstraint?.isActive = false
            progressLeadingConstraint = progressView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor)
            progressLeadingConstraint?.isActive = true
            
            if case .single = sliderValue {
            } else {
                sliderValue = .single(0.5)
            }
            
        case .range:
            secondThumbView.isHidden = false
            removeMarks()
            progressLeadingConstraint?.isActive = false
            progressLeadingConstraint = progressView.leadingAnchor.constraint(equalTo: secondThumbView.centerXAnchor)
            progressLeadingConstraint?.isActive = true
            
            if case .range = sliderValue {
            } else {
                sliderValue = .range(min: 0.3, max: 0.7)
            }
            
        case .marked(let count):
            secondThumbView.isHidden = true
            setupMarks(count: count)
            progressLeadingConstraint?.isActive = false
            progressLeadingConstraint = progressView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor)
            progressLeadingConstraint?.isActive = true
            
            if case .marked = sliderValue {
            } else {
                let middleIndex = count / 2
                let middleValue = valueForMarkIndex(middleIndex, totalMarks: count)
                sliderValue = .marked(value: middleValue, index: middleIndex)
            }
        }
        
        applyConfiguration()
        updateThumbPositions(animated: false)
    }
    
    private func setupMarks(count: Int) {
        removeMarks()
        
        guard count > 1 else { return }
        
        let trackWidth = bounds.width - configuration.thumbSize
        let markSize: CGFloat = 10
        
        for i in 0..<count {
            let markContainer = UIView()
            markContainer.backgroundColor = .clear
            markContainer.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(markContainer, aboveSubview: trackView)

            let markInner = UIView()
            markInner.backgroundColor = .white
            markInner.layer.cornerRadius = (markSize - 4) / 2
            markInner.translatesAutoresizingMaskIntoConstraints = false
            markContainer.addSubview(markInner)

            markContainer.layer.cornerRadius = markSize / 2
            markContainer.layer.borderWidth = 2
            markContainer.layer.borderColor = configuration.progressColor?.cgColor ?? UIColor.systemGray.cgColor
            markContainer.backgroundColor = configuration.trackColor
            
            let percentage = CGFloat(i) / CGFloat(count - 1)
            let xPosition = (trackWidth * percentage) + configuration.thumbSize / 2
            
            NSLayoutConstraint.activate([
                markContainer.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xPosition),
                markContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
                markContainer.widthAnchor.constraint(equalToConstant: markSize),
                markContainer.heightAnchor.constraint(equalToConstant: markSize),
                
                markInner.centerXAnchor.constraint(equalTo: markContainer.centerXAnchor),
                markInner.centerYAnchor.constraint(equalTo: markContainer.centerYAnchor),
                markInner.widthAnchor.constraint(equalToConstant: markSize - 4),
                markInner.heightAnchor.constraint(equalToConstant: markSize - 4)
            ])
            
            markViews.append(markContainer)
        }
        
        bringSubviewToFront(progressView)
        bringSubviewToFront(thumbView)
        bringSubviewToFront(secondThumbView)
    }
    
    private func removeMarks() {
        markViews.forEach { $0.removeFromSuperview() }
        markViews.removeAll()
    }
    
    private func applyConfiguration() {
        // Track
        trackView.backgroundColor = configuration.trackColor
        trackView.layer.cornerRadius = configuration.trackHeight / 2
        
        // Progress
        if let gradientColors = configuration.progressGradient, gradientColors.count > 1 {
            setupGradient(colors: gradientColors)
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
            progressView.backgroundColor = configuration.progressColor ?? .systemBlue
        }
        progressView.layer.cornerRadius = configuration.trackHeight / 2
        progressView.clipsToBounds = true
        
        // Thumbs
        applyThumbStyle(thumbView)
        applyThumbStyle(secondThumbView)

        markViews.forEach { markView in
            markView.backgroundColor = configuration.trackColor.withAlphaComponent(0.5)
        }
        
        // Haptic
        if configuration.hapticMode.isEnabled {
            feedbackGenerator = UIImpactFeedbackGenerator(style: configuration.hapticMode.feedbackStyle)
            feedbackGenerator?.prepare()
        } else {
            feedbackGenerator = nil
        }
        
        // Update constraints
        trackHeightConstraint?.constant = configuration.trackHeight
        progressHeightConstraint?.constant = configuration.trackHeight
        thumbWidthConstraint?.constant = configuration.thumbSize
        thumbHeightConstraint?.constant = configuration.thumbSize
        secondThumbWidthConstraint?.constant = configuration.thumbSize
        secondThumbHeightConstraint?.constant = configuration.thumbSize
        trackLeadingConstraint?.constant = configuration.thumbSize / 2
        trackTrailingConstraint?.constant = -configuration.thumbSize / 2
        
        setNeedsLayout()
        layoutIfNeeded()
        updateThumbPositions(animated: false)
    }
    
    private func applyThumbStyle(_ thumb: UIView) {
        thumb.backgroundColor = configuration.thumbColor
        thumb.layer.cornerRadius = configuration.thumbSize / 2
        
        if configuration.thumbShadow {
            thumb.layer.shadowColor = UIColor.black.cgColor
            thumb.layer.shadowOpacity = 0.2
            thumb.layer.shadowOffset = CGSize(width: 0, height: 2)
            thumb.layer.shadowRadius = 4
        } else {
            thumb.layer.shadowOpacity = 0
        }
        
        if configuration.thumbGlow {
            thumb.layer.shadowColor = (configuration.progressColor ?? .systemBlue).cgColor
            thumb.layer.shadowOpacity = 0.6
            thumb.layer.shadowRadius = 8
        }
    }
    
    private func setupGradient(colors: [UIColor]) {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = configuration.trackHeight / 2
        
        progressView.backgroundColor = .clear
        progressView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = progressView.bounds
        updateThumbPositions(animated: false)
        
        if case .marked(let count) = mode {
            if markViews.isEmpty || markViews.count != count {
                setupMarks(count: count)
            } else {
                let trackWidth = bounds.width - configuration.thumbSize
                for (i, markView) in markViews.enumerated() {
                    let percentage = CGFloat(i) / CGFloat(count - 1)
                    let xPosition = (trackWidth * percentage) + configuration.thumbSize / 2
                    
                    if let constraint = markView.constraints.first(where: {
                        $0.firstAttribute == .centerX
                    }) {
                        constraint.constant = xPosition
                    }
                }
            }
        }
    }
    
    // MARK: - Value Updates
    
    private func updateValues() {
        switch sliderValue {
        case .single(let val):
            sliderValue = .single(clampValue(val))
        case .range(let min, let max):
            sliderValue = .range(min: clampValue(min), max: clampValue(max))
        case .marked(_, let index):
            if case .marked(let count) = mode {
                let newValue = valueForMarkIndex(index, totalMarks: count)
                sliderValue = .marked(value: newValue, index: index)
            }
        }
    }
    
    private func updateThumbPositions(animated: Bool) {
        switch sliderValue {
        case .single(let val):
            updateThumbPosition(val, constraint: thumbCenterXConstraint, animated: animated)
            
        case .range(let min, let max):
            updateThumbPosition(min, constraint: secondThumbCenterXConstraint, animated: animated)
            updateThumbPosition(max, constraint: thumbCenterXConstraint, animated: animated)
            
        case .marked(let val, _):
            updateThumbPosition(val, constraint: thumbCenterXConstraint, animated: animated)
        }
        
        if animated {
            UIView.animate(
                withDuration: configuration.animationDuration,
                delay: 0,
                options: [.curveEaseOut, .beginFromCurrentState],
                animations: {
                    self.layoutIfNeeded()
                }
            )
        } else {
            layoutIfNeeded()
        }
    }
    
    private func updateThumbPosition(_ value: Float, constraint: NSLayoutConstraint?, animated: Bool) {
        let percentage = CGFloat((value - minimumValue) / (maximumValue - minimumValue))
        let trackWidth = bounds.width - configuration.thumbSize
        let newConstant = (trackWidth * percentage) + configuration.thumbSize / 2
        constraint?.constant = newConstant
    }
    
    // MARK: - Gesture Handlers
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            if case .range = mode {
                activeThumb = findClosestThumb(to: location)
            } else {
                activeThumb = thumbView
            }
            
            isTrackingg = true
            
            if configuration.hapticMode.isEnabled {
                feedbackGenerator?.impactOccurred()
            }
            
            sendActions(for: .touchDown)
            animateThumb(activeThumb!, scale: 1.2)
            
        case .changed:
            let oldValue = getCurrentValueForActiveThumb()
            updateValueForLocation(location)
            let newValue = getCurrentValueForActiveThumb()
            
            handleContinuousHaptic(oldValue: oldValue, newValue: newValue)
            
        case .ended, .cancelled:
            isTrackingg = false
            sendActions(for: .touchUpInside)
            if let thumb = activeThumb {
                animateThumb(thumb, scale: 1.0)
            }
            activeThumb = nil
            
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if case .range = mode {
            activeThumb = findClosestThumb(to: location)
        } else {
            activeThumb = thumbView
        }
        
        updateValueForLocation(location, animated: true)
        
        if configuration.hapticMode.isEnabled {
            feedbackGenerator?.impactOccurred()
        }
        
        activeThumb = nil
    }
    
    private func findClosestThumb(to location: CGPoint) -> UIView {
        let distanceToFirst = abs(location.x - thumbView.center.x)
        let distanceToSecond = abs(location.x - secondThumbView.center.x)
        return distanceToFirst < distanceToSecond ? thumbView : secondThumbView
    }
    
    private func getCurrentValueForActiveThumb() -> Float {
        switch sliderValue {
        case .single(let val):
            return val
        case .range(let min, let max):
            return activeThumb == thumbView ? max : min
        case .marked(let val, _):
            return val
        }
    }
    
    private func updateValueForLocation(_ location: CGPoint, animated: Bool = false) {
        let trackWidth = bounds.width - configuration.thumbSize
        let adjustedX = location.x - configuration.thumbSize / 2
        let percentage = Float(max(0, min(adjustedX / trackWidth, 1)))
        let newValue = minimumValue + (maximumValue - minimumValue) * percentage
        
        switch mode {
        case .default:
            sliderValue = .single(clampValue(newValue))
            
        case .range:
            if activeThumb == thumbView {
                let currentMin = rangeValues.min
                let clampedMax = max(currentMin, clampValue(newValue))
                sliderValue = .range(min: currentMin, max: clampedMax)
            } else {
                let currentMax = rangeValues.max
                let clampedMin = min(currentMax, clampValue(newValue))
                sliderValue = .range(min: clampedMin, max: currentMax)
            }
            
        case .marked(let count):
            let markIndex = findNearestMarkIndex(for: newValue, totalMarks: count)
            let markValue = valueForMarkIndex(markIndex, totalMarks: count)
            sliderValue = .marked(value: markValue, index: markIndex)
            
            if configuration.hapticMode.isEnabled {
                feedbackGenerator?.impactOccurred(intensity: 0.7)
            }
        }
        
        updateThumbPositions(animated: animated)
    }
    
    // MARK: - Marked Mode Helpers
    
    private func findNearestMarkIndex(for value: Float, totalMarks: Int) -> Int {
        let normalizedValue = (value - minimumValue) / (maximumValue - minimumValue)
        let index = Int(round(normalizedValue * Float(totalMarks - 1)))
        return max(0, min(index, totalMarks - 1))
    }
    
    private func valueForMarkIndex(_ index: Int, totalMarks: Int) -> Float {
        let percentage = Float(index) / Float(totalMarks - 1)
        return minimumValue + (maximumValue - minimumValue) * percentage
    }
    
    // MARK: - Helpers
    
    private func clampValue(_ value: Float) -> Float {
        return min(max(value, minimumValue), maximumValue)
    }
    
    private func handleContinuousHaptic(oldValue: Float, newValue: Float) {
        let mode = configuration.hapticMode
        guard mode.isContinuous else { return }
        
        let normalizedOld = (oldValue - minimumValue) / (maximumValue - minimumValue)
        let normalizedNew = (newValue - minimumValue) / (maximumValue - minimumValue)
        
        if floor(normalizedOld / mode.hapticStep) != floor(normalizedNew / mode.hapticStep) {
            feedbackGenerator?.impactOccurred(intensity: 0.5)
        }
    }
    
    private func animateThumb(_ thumb: UIView, scale: CGFloat) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.curveEaseOut, .beginFromCurrentState],
            animations: {
                thumb.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        )
    }
    
    // MARK: - Accessibility
//    
//    public override var isAccessibilityElement: Bool {
//        get { true }
//        set { }
//    }
//    
//    public override var accessibilityTraits: UIAccessibilityTraits {
//        get { .adjustable }
//        set { }
//    }
//    
//    public override var accessibilityValue: String? {
//        get {
//            switch sliderValue {
//            case .single(let val):
//                let percentage = Int((val - minimumValue) / (maximumValue - minimumValue) * 100)
//                return "\(percentage)%"
//            case .range(let min, let max):
//                let minPercentage = Int((min - minimumValue) / (maximumValue - minimumValue) * 100)
//                let maxPercentage = Int((max - minimumValue) / (maximumValue - minimumValue) * 100)
//                return "Range: \(minPercentage)% to \(maxPercentage)%"
//            case .marked(_, let index):
//                if case .marked(let count) = mode {
//                    return "Position \(index + 1) of \(count)"
//                }
//                return nil
//            }
//        }
//        set { }
//    }
//    
//    public override func accessibilityIncrement() {
//        let step = (maximumValue - minimumValue) / 10
//        
//        switch mode {
//        case .default:
//            value = min(value + step, maximumValue)
//        case .range:
//            let (min, max) = rangeValues
//            rangeValues = (min, min(max + step, maximumValue))
//        case .marked(let count):
//            if case .marked(_, let index) = sliderValue, index < count - 1 {
//                let newIndex = index + 1
//                let newValue = valueForMarkIndex(newIndex, totalMarks: count)
//                sliderValue = .marked(value: newValue, index: newIndex)
//            }
//        }
//        
//        if configuration.hapticMode.isEnabled {
//            feedbackGenerator?.impactOccurred()
//        }
//    }
//    
//    public override func accessibilityDecrement() {
//        let step = (maximumValue - minimumValue) / 10
//        
//        switch mode {
//        case .default:
//            value = max(value - step, minimumValue)
//        case .range:
//            let (min, max) = rangeValues
//            rangeValues = (max(min - step, minimumValue), max)
//        case .marked(let count):
//            if case .marked(_, let index) = sliderValue, index > 0 {
//                let newIndex = index - 1
//                let newValue = valueForMarkIndex(newIndex, totalMarks: count)
//                sliderValue = .marked(value: newValue, index: newIndex)
//            }
//        }
//        
//        if configuration.hapticMode.isEnabled {
//            feedbackGenerator?.impactOccurred()
//        }
//    }
}
