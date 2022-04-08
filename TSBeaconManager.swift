//
//  TSBeaconManager.swift
//  Pods-TSRTLS_Example
//
//  Created by Steeven Sylveus on 1/30/22.
//

import UIKit
import CoreLocation

public class TSBeaconManager {
    public static let shared = TSBeaconManager()
    
    private var beaconsObservable: NSObjectProtocol?
    private let beaconDetected = "beaconDetected"
    private let beaconRSSIUpdate = "beaconRSSIUpdate"
    var isGettingIdentifiers = false
    private var timer: Timer?
    var beacons = [String: TSBeacon]()
    var trackingDevices = [String: TSDevice]()
    
    private init() {
        //Singleton instance
    }
    
    func observeBeaconRanged(completion: @escaping(([TSBeacon])) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: Notification.Name(beaconDetected), object: nil, queue: nil) { (notification) in
            
            if let beacons = notification.object as? [TSBeacon] {
                completion(beacons)
            }
        }
    }
    
    func observeBeaconRSSI(beaconIdentifier: String, completion: @escaping((TSBeacon)) -> Void) -> NSObjectProtocol {
        
        return NotificationCenter.default.addObserver(forName: Notification.Name(beaconRSSIUpdate), object: nil, queue: nil) { (notification) in
            
            if let beacon = notification.object as? TSBeacon, beacon.beaconIdentifier == beaconIdentifier  {
                
                completion(beacon)
            }
            
        }
    }
    
    func initializeBeaconObserver() {
        beaconsObservable = TSLocationManager.shared.observeBeaconRanged(completion: { (notification) in
            
            if let beacons = notification.object as? [CLBeacon] {
                self.process(beacons: beacons, currentLocation: TSLocationManager.shared.currentLocation)
            }
        })
    }
    
    func process(beacons: [CLBeacon], currentLocation: CLLocation?) {
        
        for clBeacon in beacons {
            
            let beacon = TSBeacon(beacon: clBeacon, currentLocation: currentLocation)
            beacon.proximity = clBeacon.proximity
            
            if let key = getKey(beacon: beacon) {
                if let savedBeacon = TSBeaconManager.shared.beacons[key], let savedRSSI = savedBeacon.RSSI, let rssi = beacon.RSSI {
                    let beaconIdentifier = savedBeacon.beaconIdentifier
                    beacon.beaconIdentifier = beaconIdentifier
                    beacon.assetType = savedBeacon.assetType
                    beacon.assetIdentifier = savedBeacon.assetIdentifier
                    
                    if rssi != 0 {
                        if rssi >= savedRSSI  {
                            TSBeaconManager.shared.beacons[key] = beacon
                        }
                        
                        //Update modar if Beacon changes
                        if rssi != savedRSSI {
                            NotificationCenter.default.post(name: Notification.Name(beaconRSSIUpdate), object: beacon)
                        }
                    }
                    
                } else {
                    
                    if let device = trackingDevices[key] {
                        beacon.beaconIdentifier = device.tagIdentifier
                        beacon.assetType = device.assetType
                        beacon.assetIdentifier = device.assetIdentifier
                        
                        TSBeaconManager.shared.beacons[key] = beacon
                        
                        //RSSI update for Modar Mode
                        NotificationCenter.default.post(name: Notification.Name(beaconRSSIUpdate), object: beacon)
                        
                    }
                }
                
                NotificationCenter.default.post(name: Notification.Name(beaconDetected), object: getBeaconWithIdentifiers())
            }
        }
    }
    
    /// This function generates a unique key for saving the beacons to the dictionary
    ///
    /// - Parameter beacon: the relevant beacon
    /// - Returns: return a unique key using the beaconid, the major and minor.
    func getKey(beacon: TSBeacon) -> String? {
        if let UUID = beacon.beaconId, let minor = beacon.minor {
            return "\(UUID)-\(minor)"
        }
        
        return nil
    }
    
    func getKey(device: TSDevice) -> String? {
        if let UUID = device.uuid?.replacingOccurrences(of: "-", with: ""), let minor = device.minor {
            return "\(UUID)-\(minor)"
        }
        
        return nil
    }
    
    func beaconExists(UUID: String, minor: String) -> Bool {
        let beacon = beacons["\(UUID)-\(minor)"]
        return beacon != nil
    }
    
    func getBeaconWithIdentifiers() -> [TSBeacon] {
        var beacons = [TSBeacon]()
        for (_, beacon) in TSBeaconManager.shared.beacons {
            if beacon.beaconIdentifier != "" && beacon.beaconIdentifier != nil {
                beacons.append(beacon)
            }
        }
        
        return beacons
    }
    
    func updateTrackingDevices(devices: [TSDevice]) {
        for device in devices {
            if let key = getKey(device: device) {
                trackingDevices[key] = device
            }
        }
    }
}

