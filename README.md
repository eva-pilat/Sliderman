# Sliderman
Custom UIKit sliders
A beautiful, highly customizable slider control for iOS with multiple operating modes and pre-defined styles.

![iOS Version](https://img.shields.io/badge/iOS-13.0%2B-blue)
![Swift Version](https://img.shields.io/badge/Swift-5.0-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

✨ **Multiple Modes**
- Default: Single value slider
- Range: Dual-thumb range selector
- Marked: Discrete snap-to positions

🎨 **Pre-defined Styles**
- iOS, Vibrant, Minimal, Neon, Sunset, Ocean, Grape, Mint

📳 **Advanced Haptics**
- Multiple feedback modes
- Customizable intensity

🎯 **Highly Customizable**
- Track height & color
- Thumb size, color, shadow, glow
- Gradient support
- Animation duration

## Installation

### Swift Package Manager

Add to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/YOUR_USERNAME/CustomSlider.git", from: "0.1.0")
]
```

Or in Xcode: **File → Add Packages** → paste the URL: https://github.com/eva-pilat/Sliderman.git.

### CocoaPods

Add to your `Podfile`:
```ruby
pod 'CustomSlider', '~> 0.1.0'
```

Then run:
```bash
pod install
```

## Quick Start

### Default Mode
```swift
import CustomSlider

let slider = CustomSlider()
slider.setStyle(.ocean)
slider.value = 0.5
view.addSubview(slider)
```

### Range Mode
```swift
let rangeSlider = CustomSlider()
rangeSlider.setStyle(.sunset)
rangeSlider.setMode(.range)
rangeSlider.minimumValue = 0
rangeSlider.maximumValue = 100
rangeSlider.rangeValues = (20, 80)
```

### Marked Mode
```swift
let markedSlider = CustomSlider()
markedSlider.setStyle(.grape)
markedSlider.setMode(.marked(count: 5))
```

## Customization

### Using Pre-defined Styles
```swift
slider.setStyle(.neon)      // Colorful gradient with glow
slider.setStyle(.minimal)   // Clean black and white
slider.setStyle(.vibrant)   // Bold pink
```

### Custom Configuration
```swift
var config = SliderConfiguration()
config.trackHeight = 8
config.thumbSize = 40
config.progressGradient = [.systemPink, .systemOrange, .systemYellow]
config.thumbGlow = true
config.hapticMode = .mediumContinuous

slider.configuration = config
```

### Available Styles

- `.default` - Standard style
- `.iOS` - Native iOS appearance
- `.vibrant` - Bold pink
- `.minimal` - Clean B&W
- `.neon` - Multi-color gradient
- `.sunset` - Yellow to red
- `.ocean` - Cyan to indigo
- `.grape` - Purple gradient
- `.mint` - Mint to teal

## Documentation

Full API documentation is available in the source code using Swift DocC comments. 
Press `Option + Click` on any API in Xcode to see detailed documentation.

## Requirements

- iOS 16.0+
- Swift 5.0+
- Xcode 12.0+

## License

Sliderman is available under the MIT license. See LICENSE file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
