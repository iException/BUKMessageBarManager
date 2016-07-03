Pod::Spec.new do |s|
  s.name             = 'BUKMessageBarManager'
  s.version          = '0.1.0'
  s.summary          = 'a drop down message bar'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'a drop down message bar like notification'

  s.homepage         = 'https://github.com/iException/BUKMessageBarManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'monzy613' => 'monzy613@gmail.com' }
  s.source           = { :git => 'https://github.com/iException/BUKMessageBarManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'BUKMessageBarManager/Classes/**/*'
  
  s.dependency 'BlocksKit'
# s.dependency 'MZGoogleStyleButton', :git => 'https://github.com/monzy613/MZGoogleStyleButton.git'
end
