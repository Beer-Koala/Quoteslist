platform :ios, '16.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Quoteslist' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Quoteslist
  pod 'SwiftLint'
  # DB
  pod 'RealmSwift', '~>10'
  # Charts
  pod 'DGCharts'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
