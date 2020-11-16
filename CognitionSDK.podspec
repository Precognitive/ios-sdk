Pod::Spec.new do |s|
    s.name         = "CognitionSDK"
    s.version      = "2.0.1"
    s.summary      = "Precognitive iOS SDK"
    s.description  = "An iOS SDK for integration with Precognitive's fraud detection"
    s.homepage     = "https://precognitive.com/"
    s.license      = { 
        :type => 'Commercial'
    }
    s.author       = 'Precognitive'
    s.source       = { :git => "$HOME/Documents/projects/cognition-ios-dist.git", :tag => "#{s.version}" }
    s.vendored_frameworks = "CognitionSDK.xcframework"
    s.platform = :ios
    s.ios.deployment_target  = '11.0'
end