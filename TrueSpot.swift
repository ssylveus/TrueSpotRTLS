//
//  TrueSpot.swift
//  TSRTLS
//
//  Created by Steeven Sylveus on 3/13/22.
//

import Foundation


/// TureSpot class is your single point of entry to access our SDK. All relevant function can be found here.
public class TrueSpot {
    public static let shared = TrueSpot()
    
    private init() {}
    
    
    /// Debug mode flag. Keep this off for production. Only for debugging purposes.
    static var isDebugMode = false
    
    
    /// Configure is the entry point to initializing the SDK.
    /// - Parameters:
    ///   - tenatId: the tenantId for your organization - will be provided for your organization
    ///   - clientSecret: client secret - will be provided for your organization
    ///   - isDebugMode: If turn on, you can see logs as you use the SDK,
    public static func configure(tenatId: String, clientSecret: String, isDebugMode: Bool) {
        TrueSpot.isDebugMode = isDebugMode
        //TSLocationManager.beaconUUID = beaconUUID
        Credentials.tenantId = tenatId
        Credentials.clientSecret = clientSecret
        BeaconServices().authenticate()
    }
    
    /// In order to get access device location, apple requires us to ask the user permission. Call this function when you need to request permission to the user
    public func requestLocationPermission() {
        TSLocationManager.shared.requestLocationPermission()
    }
    
    
    /// Upon initializing the SDK, the SDK will internally call start scanning. This is for the purpose scanning beacons. You can call this function counterpart stopScanning() if you no longer want to scan.
    public func startScanning() {
        TSLocationManager.shared.startScanning()
    }
    
    
    /// Call this function when you no longer want scan for beacons
    public func stopScanning() {
        TSLocationManager.shared.stopScanning()
    }
    
    
    /// Turedar mode is our real time beacon finder. Calling this function will launch our TrudarMode interface, where you can search for your beacon
    /// - Parameters:
    ///   - viewController: The viewcontroller that will present the TrueDarMode
    ///   - device: TSDevice object which contains tag and other relevant infor for TuredarMode to be able to search for your beacon
    public func launchTruedarMode(from viewController: UIViewController, device: TSDevice) {
        let truedarVC = ModarViewController.create(device: device)
        viewController.present(truedarVC, animated: true, completion: nil)
    }
    
    
    /// Use this function to get notified of nearby beacons. One use case if for detecting beacons for pairing.
    /// - Parameter completion: completion handler everytime a beacon is detected
    /// - Returns: NSObjectProtocol Observable pattern
    public func observeBeaconRanged(completion: @escaping(([TSBeacon])) -> Void) -> NSObjectProtocol {
        return TSBeaconManager.shared.observeBeaconRanged(completion: completion)
    }
    
}

// Mark Services
extension TrueSpot {
    
    /// Get list of tracking devices for per your appID
    /// - Parameter completion: callback with a list of TSDevice
    public func getTrackingDevices(completion: @escaping(_ devices: [TSDevice], _ error: Error?) -> Void) {
        BeaconServices().getTrackingDevices(completion: completion)
    }
    
    
    /// Use this function for pairing assets.
    /// - Parameters:
    ///   - assetIdentifier: identifier of the asset to pari
    ///   - assetType: the type of asset
    ///   - tagId: the tagId
    ///   - completion: callback for if the paring was successful or not.
    public func pair(assetIdentifier: String, assetType: String, tagId: String, completion: @escaping (_ device: TSDevice?, _ error: Error?) -> Void) {
        BeaconServices().pair(assetIdentifier: assetIdentifier, assetType: assetType, tagId: tagId, completion: completion)
    }
    
    func unpair(deviceID: String, pairingId: String, completion: @escaping (_ error: Error?) -> Void) {
        BeaconServices().unpair(deviceID: deviceID, pairingId: pairingId, completion: completion)
    }
}

