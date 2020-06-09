#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint simple_s3.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'simple_s3'
  s.version          = '0.0.1'
  s.summary          = 'An advanced yet simple to use AWS S3 plugin for upload and delete ANY file in Android and iOS with upload percentage.'
  s.description      = <<-DESC
An advanced yet simple to use AWS S3 plugin for upload and delete ANY file in Android and iOS with upload percentage.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  
  
  s.dependency 'AWSS3'
  s.dependency 'AWSCore'
  s.dependency 'AWSCognito'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
