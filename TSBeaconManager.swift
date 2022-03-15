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
            
            NotificationCenter.default.post(name: Notification.Name(beaconRSSIUpdate), object: beacon)
        }
    }
}
