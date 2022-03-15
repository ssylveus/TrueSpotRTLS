# TrueSpot RTLS SDK Documentation #

TSRTLS is TrueSpot Real Time Location Services SDK. Allows you to quickly find tags that are tied to specific assets.

### Features ###
- Get list of tags
- Get Tag Info
- Get last known location of tag
- Truedar Mode - find tag in real time

### Instalations ###
The SDK can be added to your project using [CocoaPods dependency manager](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/) by adding the following line to your `Podfile`:

```ruby
pod 'TSRTLS'
```

### Exposed Classes ###
- TrueSpot.swift
- TSDevice
- TSDevice.Location

### Exposed Functions ###
- public static func configure(apiId: String, isDebugMode: Bool)
-  public func requestLocationPermission()
-  public func startScanning()
-  public func stopScanning()
-  public func launchTruedarMode(from viewController: UIViewController, device: TSDevice)
-  public func getTrackingDevices(completion: @escaping(_ devices: [String], _ error: Error?) -> Void)
-  public func getDeviceInfo(deviceID: String, completion: @escaping(_ device: TSDevice?, _ error: Error?) -> Void)


### Usage ###
- In order to start using the SDK, you must call the configure function in your Appdelegate.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
   // Override point for customization after application launch.
        
   TrueSpot.configure(apiId: "AppID", isDebugMode: false)
   return true
}
```
Configure takes in 2 parameters. The appID and debug flag. It is recommended to set debug flag to false for production app. Passing true, will pring out relevant logs.

- Getting tracking devices

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    TrueSpot.shared.getTrackingDevices { devices, error in
        print(devices)
    }
}
```
Get tracking devices will return a list of string where each element is a beacon Identifier. i.e ["000-1345", "000-2341]

- Get Device Info
Once you have a tag identifier, you can call below method to get detail info about the tag

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    TrueSpot.shared.getDeviceInfo(deviceID: ["000-1121"]) { device, error in
        print(device)
    }
}
```

- Truedar Mode

If you want to lookup tag real time, you can launch TruedarMode
```swift
TrueSpot.shared.launchTruedarMode(from: self, device: device)
```
