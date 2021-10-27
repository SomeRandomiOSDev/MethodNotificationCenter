Pod::Spec.new do |s|
  
  s.name         = "MethodNotificationCenter"
  s.version      = "0.1.2"
  s.summary      = "Simple Objective-C Runtime Injection"
  s.description  = <<-DESC
                   A lightweight framework enabling easy snooping on Objective-C methods for iOS, macOS, and tvOS.
                   DESC
  
  s.homepage     = "https://github.com/SomeRandomiOSDev/MethodNotificationCenter"
  s.license      = "MIT"
  s.author       = { "Joe Newton" => "somerandomiosdev@gmail.com" }
  s.source       = { :git => "https://github.com/SomeRandomiOSDev/MethodNotificationCenter.git", :tag => s.version.to_s }

  s.ios.deployment_target     = '9.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files      = 'Sources/MethodNotificationCenter/**/*.{h,m,s}'
  s.module_map        = 'Sources/MethodNotificationCenter/module/module.modulemap'
  s.swift_versions    = ['4.0', '4.2', '5.0']
  s.cocoapods_version = '>= 1.7.3'

  s.test_spec 'Tests' do |ts|
    ts.ios.deployment_target     = '9.0'
    ts.macos.deployment_target   = '10.10'
    ts.tvos.deployment_target    = '9.0'
    ts.watchos.deployment_target = '2.0'

    ts.pod_target_xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$PODS_TARGET_SRCROOT/Sources/MethodNotificationCenter/include',
                               'HEADER_SEARCH_PATHS' => '$PODS_TARGET_SRCROOT/Sources/MethodNotificationCenter/include' }
    ts.source_files        = 'Tests/**/*.{m,swift}'
  end
  
end
