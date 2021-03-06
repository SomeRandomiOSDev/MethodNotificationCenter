Pod::Spec.new do |s|
  
  s.name         = "MethodNotificationCenter"
  s.version      = "0.1.0"
  s.summary      = "Simple Objective-C Runtime Injection"
  s.description  = <<-DESC
                   A lightweight framework enabling easy snooping on Objective-C methods for iOS, macOS, and tvOS.
                   DESC
  
  s.homepage     = "https://github.com/SomeRandomiOSDev/MethodNotificationCenter"
  s.license      = "MIT"
  s.author       = { "Joseph Newton" => "somerandomiosdev@gmail.com" }

  s.ios.deployment_target     = '11.0'
  s.macos.deployment_target   = '10.10'
  s.tvos.deployment_target    = '9.0'

  s.source            = { :git => "https://github.com/SomeRandomiOSDev/MethodNotificationCenter.git", :tag => s.version.to_s }
  s.source_files      = 'Sources/**/*.{h,m,s}'
  s.swift_versions    = ['4.0', '4.2', '5.0']
  s.cocoapods_version = '>= 1.7.3'

  s.test_spec 'Tests' do |ts|
    ts.ios.deployment_target   = '11.0'
    ts.macos.deployment_target = '10.10'
    ts.tvos.deployment_target  = '9.0'

    ts.source_files            = 'Tests/**/*.{m,swift}'
  end
  
end
