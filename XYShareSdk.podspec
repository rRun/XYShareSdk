#
# Be sure to run `pod lib lint XYShareSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
# 命令：pod sepc lint 文件名.podspec --sources='xxx,xxx'

Pod::Spec.new do |s|
  s.name             = 'XYShareSdk'
  s.version          = '0.1.1'
  s.summary          = '分享［包括，微信，qq,微博］'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                     组件化，添加分享。
                       DESC

  s.homepage         = 'https://github.com/rRun/XYShareSdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hexy' => 'hexy@cdfortis.com' }
  s.source           = { :git => 'https://github.com/rRun/XYShareSdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'XYShareSdk/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XYShareSdk' => ['XYShareSdk/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'WeChatSDK', '~> 1.7.3'
    s.dependency 'TencentOpenAPI', '~> 3.1.0'
    s.dependency 'Weibo', '~> 2.4.2'
    s.dependency 'Aspects', '~> 1.4.1'

end


