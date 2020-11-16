# Cognition iOS SDK

## Installing

**Add the following to your Podfile.**

`pod 'CognitionSDK', :git => 'https://github.com/Precognitive/ios-sdk.git', :tag => '2.0.1'`


## (Internal Only) Publishing a New Version
 * Replace `CognitionSDK.xcframework` with the new version of the framework.
 * Update the version in `CognitionSDK.podspec`.
 * Create a tag named the new version from `CognitionSDK.podspec`.
 * Push the tag.
 * Update the documentation above to have the new version.
 * Push to master.