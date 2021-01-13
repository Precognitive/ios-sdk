# Cognition iOS SDK

## Installing

**Add the following to your Podfile.**

`pod 'CognitionSDK', :git => 'https://github.com/Precognitive/ios-sdk.git', :tag => '2.1.1'`

## SDK Docs

[Full SDK Documentation](https://precognitive.github.io/ios-sdk/docs/2.1.1).

## Usage & Integration

To integrate the SDK you will need to follow the examples below depending on your Application language.

### Bootstrap Integration

```swift
// AppDelegate.swift
import UIKit
import CognitionSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let cognition: Cognition = Cognition.shared

        // Presets (examples shown, please request real data from account manager)
        cognition.setApiKey("21243-143243-1234124") // example API Key
        cognition.setBehaviorUrl("https://behavior.example.com")
        cognition.setDeviceUrl("https://device.example.com")
        
        // If necessary, please fill in the below event id i.e. `cognition.setEventId(custom.getEventId())`
        // cognition.setEventId("CUSTOM_EVENTID")
        
        cognition.start()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let cognition: Cognition = Cognition.shared
        cognition.analyze()
    }

}
```

## Fetching Sesison Id
To fetch the session id, use the following.
```swift
let cognition: Cognition = Cognition.shared
let sessionid = cognition.sessionId
```

## Lifecycle Integration

Below are example classes that could exist in your application. The examples are meant to provide guidance on when during your applications lifecycle to call certain methods on the SDK (i.e. Cognition#analyze, Cognition#resetSession) 

```swift

// EcommerceCheckout.swift
import CognitionSDK

class EcommerceCheckout {
   func checkout(_ data) {
      
      // Submit the device data prior to checking out
      Cognition.shared.analyze()
      
      this.submitTransaction(data)
      
      // if you are leveraging Cognitions sessionID instead of your own (eventID) please reset session
      Cognition.shared.resetSession()
   }
}

// AccountOpen.swift
import CognitionSDK

class AccountOpen {
   func open(_ data) {
      
      // Submit the device data prior to opening account
      Cognition.shared.analyze()
      
      this.submitOpen(data)
      
      // if you are leveraging Cognitions sessionID instead of your own (eventID) please reset session
      Cognition.shared.resetSession()
   }
}

// Auth.swift
import CognitionSDK

class Auth {
   func login(_ username, _ password) {
      
      // Submit the device data prior to login
      Cognition.shared.analyze()
      
      this.submitLogin()
   }

   func logout() {
      this.submitLogout()
   
      // Reset the session after logging out
      Cognition.shared.resetSession()
   }
}
```

## Data Groups

Cognition sends a variety of data with each request. You can opt in or opt out of any of these groups.

The following groups are included by default: `device`, `bundle`, `network`, `sys`, `location`, `motion`.

You can optionally include the following groups: `altimeter`, `battery`, and `pageView`.

`altimeter` works without any additional effort.

`motion` works without any additional effort if you aren't already using a `CMMotionManager` in your app. (Please see the Motion section if you do use a `CMMotionManager` in your app.)

`location` requires Core Location to be implemented in your app, because Core Location requires permission from the user. See the Location section for more details.

`battery` requires that `UIDevice.current.isBatteryMonitoringEnabled = true` is set somewhere in your app. Otherwise, it will report a battery level of -1. You must also include the `device` group. (By default, the `device` group is automatically included.)

`pageView` allows you to manually register your view controllers as they appear.

## How to use the Altimeter

Add the following to your code prior to calling the `start` method:

```swift
Cognition.shared.includeDataGroup(.altimeter)
```

## Motion 

### How to use Motion data

#### Your app does not use a `CMMotionManager`

Add the following to your code prior to calling the `start` method:

```swift
Cognition.shared.includeDataGroup(.motion)
```

#### Your app does use a `CMMotionManager`

Add the following to your code prior to calling the `start` method:

```swift
Cognition.shared.includeDataGroup(.motion)
Cognition.shared.enableCustomMotion(enabled: true)
// You may now submit motion data via the update method, prior to calling start().
```

Because an app should only have 1 `CMMotionManager`, you MUST `enableCustomMotion`. Motion performance will be degraded if this flag is not set to true.

For each motion sensor you wish to use, call one of the following methods whenever you receive the matching data or error:

```swift
addDeviceMotionData(_ data: CMDeviceMotion)

addDeviceMotionError(_ error: Error)

addAccelerometerData(_ data: CMAccelerometerData)

addAccelerometerError(_ error: Error)

addGyroData(_ data: CMGyroData)

addGyroError(_ error: Error)

addMagnetometerData(_ data: CMMagnetometerData)

addMagnetometerError(_ error: Error)
```

### Adjusting how often Motion data is gathered

Motion data is generated at an extremely rapid rate (sometimes up to 100 data points per second). This will generate an enormous payload and can decrease app performance.

By default, this data is generated every 5 seconds. You may adjust the rate to be faster (not recommended) or slower, depending on your individual needs using the following methods:

```swift
setAccelerometerUpdateInterval(_ interval: TimeInterval)

setDeviceMotionUpdateInterval(_ interval: TimeInterval)

setMagnetometerUpdateInterval(_ interval: TimeInterval)

setGyroUpdateInterval(_ interval: TimeInterval)
```

## Location

Because the use of Core Location requires your app to ask the user's permission, you'll need to integrate Core Location into your app before you're able to use this feature.

Once Core Location is working in your app, follow the instructions below to use that data with Cognition. 

### How to use Location data

Add the following to your code prior to calling the `start` method:

```swift
Cognition.shared.includeDataGroup(.location)
// Start the Core Location services your app uses after this point, if you wish to capture the initial data.
// Any data generated before calling start() will be captured.
```

### How to send Location data

Cognition supports heading, location (both regular and significant location changes), and visit data. It does not provide support for regions or beacons.

Call the corresponding methods as you receive data from Core Location.

```swift
addLocations(_ locations: [CLLocation]) 

addHeading(_ heading: CLHeading) 

addVisit(_ visit: CLVisit) 
```

## Page Views

There are two ways you can track page views:
1. Use a UINavigationControllerDelegate or
1. Individually track each view controller

### Using a UINavigationControllerDelegate

Assign a delegate to each `navigationController` in your app that you want to track.

Inside of the delegate's `navigationController(UINavigationController, willShow: UIViewController, animated: Bool)` method, call the following:

```swift
Cognition.shared.addPageView(viewController: viewController)
```

### Tracking each view controller individually

For each view controller you want to track, add the following to that view controller's `viewWillAppear` method:

```swift
Cognition.shared.addPageView(viewController: self)
```

## Custom Intents

You can create intent groups, searches, and object views that meet your app's needs.

Use intent groups when a user is viewing a categorical group (example: "/categories/jeans")

Use search when the user performs a search in your app (example: user searched for "blue jeans")

Use object views when the user views a specific object such as a product or item (example: user viewed "Levi Skinny 451")

You may store metadata with any of these events. Metadata is a [String: Any] that represents valid JSON. Only standard JSON types may be used. If the metadata is invalid, it will be excluded with the data point.

```swift
addIntentGroup(value: String, metadata: [String: Any]? = nil)

addObjectView(value: String, metadata: [String: Any]? = nil)

addSearch(value: String, metadata: [String: Any]? = nil)
```

## Biometric Data

You can register user name and password fields to capture biometric data.

Call uploadBiometrics to ensure that biometrics are saved prior to submitting a decision event.

Use the following methods to register the text fields:

```swift
registerUserNameTextField(_ textField: UITextField)

registerPasswordTextField(_ textField: UITextField)

uploadBiometrics(completion: ((Error?) -> Void)?)
```


Only 1 user name field and 1 password field may be registered at a time. Registering a field assigns methods to the following events: `.editingDidBegin`, `.editingChanged`, and `editingDidEnd`. Do not assign your own methods to these events. You may continue to use the corresponding `UITextFieldDelegate` methods.


## Debugging

Additional information is available to developers while debugging.

Add the following to your code to enable debug mode:

```swift
Cognition.shared.enableDebugMode(enabled: true)
```

This will generate additional information in the payload.

You can also increase the volume of logged output by increasing the logging level. By default, the log level is set to `.none`.

```swift
setLogLevel(minLogLevel: CognitionLogLevel)
```

## Troubleshooting
If you have any issues installing the SDK, please reach out to [support@precognitive.com](mailto:support@precognitive.com) and we will get back to you regarding your issues/problems with the SDK.