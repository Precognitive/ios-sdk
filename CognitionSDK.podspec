# https://medium.com/@anuragajwani/distributing-universal-ios-frameworks-as-xcframeworks-using-cocoapods-699c70a5c961
Pod::Spec.new do |s|
    s.name                  = "CognitionSDK"
    s.version               = "2.1.2"
    s.summary               = "Precognitive iOS SDK"
    s.description           = "An iOS SDK for integration with Precognitive's fraud detection"
    s.homepage              = "https://precognitive.com/"
    s.license               = { 
        :type => 'Commercial'
    }
    s.author                = 'Precognitive'
    s.source                = { :git => "https://github.com/Precognitive/ios-sdk.git", :tag => s.version }
    s.vendored_frameworks   = "CognitionSDK.xcframework"
    s.platform              = :ios
    s.ios.deployment_target = '11.0'
    s.swift_version         = '5.0'
    s.preserve_path         = 'CognitionSDK.xcframework/ios-arm64/BCSymbolMaps', 'CognitionSDK.xcframework/ios-arm64/dSYMs/CognitionSDK.framework.dSYM' , 'CognitionSDK.xcframework/ios-arm64_x86_64-simulator/dSYMs/CognitionSDK.framework.dSYM'
end