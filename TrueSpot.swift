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
    
    public static func configure(apiId: String, isDebugMode: Bool) {
        TrueSpot.isDebugMode = isDebugMode
        //TSLocationManager.beaconUUID = beaconUUID
        Credentials.apiId = apiId
        
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
    
}

// Mark Services
extension TrueSpot {
    public func getTrackingDevices(completion: @escaping(_ devices: [String], _ error: Error?) -> Void) {
        BeaconServices().getTrackingDevices(completion: completion)
    }
    
    public func getDeviceInfo(deviceID: String, completion: @escaping(_ device: TSDevice?, _ error: Error?) -> Void) {
        
        BeaconServices().getDeviceInfo(deviceID: deviceID, completion: completion)
    }
}

