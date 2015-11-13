Pod::Spec.new do |s|
  s.name             = "EGMaterialSwitch"
  s.version          = "0.0.1"
  s.summary          = "Implementation of Google's 'Switch' of Material design."
  s.homepage         = "https://github.com/enisgayretli/EGMaterialSwitch"
  s.license          = 'MIT'
  s.author           = { "Enis Gayretli" => "enisgayretli@gmail.com" }
  s.source           = { :git => "https://github.com/enisgayretli/EGMaterialSwitch.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/enisgayretli'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'EGMaterialSwitch/EGMaterialSwitch/*.swift'
end

