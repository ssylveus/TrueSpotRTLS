//
//  TrueSpot.swift
//  TSRTLS
//
//  Created by Steeven Sylveus on 3/13/22.
//

import Foundation

public class TrueSpot {
    public static let shared = TrueSpot()
    
    private init() {}
    
    static var isDebugMode = false
    
    public static func configure(appId: String, clientSecret: String, isDebugMode: Bool) {
        TrueSpot.isDebugMode = isDebugMode
        //TSLocationManager.beaconUUID = beaconUUID
        Credentials.appID = appId
        Credentials.clientSecret = clientSecret
        BeaconServices().authenticate()
    }
    
    public func requestLocationPermission() {
        TSLocationManager.shared.requestLocationPermission()
    }
    
    public func startScanning() {
        TSLocationManager.shared.startScanning()
    }
    
    public func stopScanning() {
        TSLocationManager.shared.stopScanning()
    }
    
    public func launchTruedarMode(from viewController: UIViewController, device: TSDevice) {
        let truedarVC = ModarViewController.create(device: device)
        viewController.present(truedarVC, animated: true, completion: nil)
    }
    
    public func observeBeaconRanged(completion: @escaping(([TSBeacon])) -> Void) -> NSObjectProtocol {
        return TSBeaconManager.shared.observeBeaconRanged(completion: completion)
    }
    
}

// Mark Services
extension TrueSpot {
    public func getTrackingDevices(completion: @escaping(_ devices: [TSDevice], _ error: Error?) -> Void) {
        BeaconServices().getTrackingDevices(completion: completion)
    }
    
    public func pair(assetIdentifier: String, assetType: String, tagId: String, completion: @escaping (_ device: TSDevice?, _ error: Error?) -> Void) {
        BeaconServices().pair(assetIdentifier: assetIdentifier, assetType: assetType, tagId: tagId, completion: completion)
    }
}

