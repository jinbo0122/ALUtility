#
# Be sure to run `pod lib lint ALUtility.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALUtility'
  s.version          = '0.3.9'
  s.summary          = 'Project Starter for personal usage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'It\'s a bunch of categories that make a project development easier'

  s.homepage         = 'https://github.com/jinbo0122/ALUtility'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jinbo0122' => 'albert_leee@me.com' }
  s.source           = { :git => 'https://github.com/jinbo0122/ALUtility.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/albert_leee'

  s.ios.deployment_target = '10.0'
  s.prefix_header_contents = '#import "ALExtension.h"'
  s.source_files = 'ALUtility/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'ALUtility' => ['ALUtility/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Photos', 'CoreGraphics', 'ImageIO', 'AssetsLibrary', 'Security', 'QuartzCore', 'Foundation', 'SystemConfiguration', 'AVFoundation', 'WebKit'
  s.libraries = 'z'
  s.dependency 'SDWebImage', '~> 4.0'
end
