Pod::Spec.new do |s|
  s.name         = 'Source'
  s.version      = '1.3.1'
  s.summary      = 'convince for image compress.'
  s.homepage     = 'https://www.jianshu.com/u/f3d3e8bb8ba8'
  s.license      = "MIT"
  s.author             = { "guolongxaing" => "zhangkui305@163.com" }
  s.social_media_url   = "https://twitter.com/guolongxaing"
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/LongXiangGuo/CompressImage.git', :tag => s.version }
  s.source_files  = 'Source/**/*.swift'
  s.framework  = 'UIKit'
end
