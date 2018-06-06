Pod::Spec.new do |s|
  s.name             = 'AGHUD'
  s.version          = '0.9.0'
  s.summary          = 'An iOS activity indicator and toast view.'
  s.description      = <<-DESC
  An iOS activity indicator and toast view. Like Loading and Toast.
                       DESC

  s.homepage         = 'https://github.com/Agenric/HUD'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AgenricWon' => 'AgenricWon@gmail.com' }
  s.source           = { :git => 'https://github.com/Agenric/HUD.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version    = '4.0'
  s.source_files     = 'HUD/Classes/HUD.swift', 'HUD/Classes/HUDExtension.swift'

  s.resource_bundles = {
    'HUD' => ['HUD/Assets/*.png']
  }

  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'SnapKit', '~> 4.0.0'

end
