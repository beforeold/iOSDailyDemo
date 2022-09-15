Pod::Spec.new do |s|


  s.name         = "LASocialization"
  s.version  = "0.0.1"
  s.summary      = "LASocialization Source."

  s.description  = <<-DESC
                   LASocialization Source description
                   DESC
  s.source = { :git => "git@gitlab.alibaba-inc.com:lazada-ios/LASocialization.git", :branch => "master"  }

  s.homepage     = "http://gitlab.alibaba-inc.com/lazada-ios/LASocialization"

  s.author       = { "Colin | 莫怠" => "guobing.sgb@alibaba-inc.com" }
  s.source           = { :git => 'git@gitlab.alibaba-inc.com:lazada-ios/LASocialization.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'LASocialization/**/*.{h,m,c,cpp,swift}'
  s.exclude_files = "LASocialization/Info.plist"
  s.resources = "LASocialization/resource/*.{bundle,xcassets,plist}"

  s.static_framework = true
  s.xcconfig         = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  
  s.dependency 'LAContentGenerator'

end
