Pod::Spec.new do |s|
  s.name             = 'MShareKit'
  s.version          = '1.0.2'
  s.summary          = 'MShareKit.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/mafeng-Bryant/MShareKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1499603656@qq.com' => 'feng.ma@patpat.com' }
  s.source           = { :git => 'https://github.com/mafeng-Bryant/MShareKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MShareKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MShareKit' => ['MShareKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MUIFont', '~> 1.0.0'
  s.dependency 'Masonry', '~> 1.0.2'
  s.dependency 'MLocalizedStringKit', '~> 1.0.0'
  s.dependency 'MLoadingViewKit', '~> 1.1.2'
  s.dependency 'SDWebImage'
  s.dependency 'FBSDKShareKit', '~> 4.33.0'
  s.dependency 'FBSDKCoreKit', '~> 4.33.0'
  s.dependency 'FBSDKLoginKit', '~> 4.33.0'
  s.dependency 'PinterestSDK', '~> 1.0.2'
  s.dependency 'TwitterKit', '~> 3.4.0'
  s.dependency 'MPopUpAlertManager', '~> 1.0.0'
  s.dependency 'MExtensions', '~> 2.0.5'
  s.dependency 'MFileManager', '~> 1.0.3'
end
