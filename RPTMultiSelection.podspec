#
# Be sure to run `pod lib lint RPTMultiSelection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RPTMultiSelection'
  s.version          = '0.1.2'
  s.summary          = 'Multi-selection input view that helps creating custom selection input view.'
  
  # set the swift value
  # s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.swift_version = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This works mainly as default component such as UIPickerView  and UITableView. You have to work with delegates for setting values and updating data model. All it gives is failsafe and semi tested component that I have been using in some of my projects.
                       DESC

  s.homepage         = 'https://github.com/rptwsthi/RPTMultiSelection'
  # s.screenshots      = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rptwsthi' => 'awasthi.arp@gmail.com' }
  s.source           = { :git => 'https://github.com/rptwsthi/RPTMultiSelection.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rptwsthi'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RPTMultiSelection/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RPTMultiSelection' => ['RPTMultiSelection/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
