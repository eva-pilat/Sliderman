Pod::Spec.new do |s|
  s.name             = 'Sliderman'
  s.version          = '0.1.1'
  s.summary          = 'A beautiful, customizable slider for iOS'
  s.description      = <<-DESC
  Sliderman is a highly customizable UIControl with multiple styles and modes.
                       DESC

  s.homepage         = 'https://github.com/eva-pilat/Sliderman.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eva Pilat' => 'evissdun@icloud.com' }
  s.source           = { :git => 'https://github.com/eva-pilat/Sliderman.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '16.0'
  s.swift_version = '5.0'
  
  s.source_files = 'Sources/Sliderman/**/*.swift'
  
  s.frameworks = 'UIKit'
end
