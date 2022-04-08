//
//  LocationManager.swift
//  Pods-TSRTLS_Example
//
//  Created by Steeven Sylveus on 1/30/22.
//

import Foundation
import CoreLocation

public class TSLocationManager: NSObject, CLLocationManagerDelegate {
    
    public static let shared = TSLocationManager()
    public var authorizationStatus: CLAuthorizationStatus?
    
    private var locationManager: CLLocationManager?
    public var currentLocation: CLLocation?
    private lazy var beaconRegion: [CLBeaconRegion] = {
        
        if let uuids = Credentials.appInfo?.uuids {
            var regions = [CLBeaconRegion]()
            
            uuids.enumerated().forEach { (index, uuid) in
                let region = CLBeaconRegion(proximityUUID: UUID(uuidString: TSLocationManager.beaconUUID)!,
                               identifier: "ranged beacons \(index)")
                regions.append(region)
            }
            
            return regions
        } else {
            let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "5C38DBDE-567C-4CCA-B1DA-40A8AD465656")!,
                           identifier: "ranged beacons \(index)")
            return [region]
        }
        
        //return []
    }()

    private let beaconRangeNotificationName = "beaconRange"
    static var beaconUUID: String = "5C38DBDE-567C-4CCA-B1DA-40A8AD465656"
    
    static var beaconUUIDs = ["5C38DBDE-567C-4CCA-B1DA-40A8AD465656"]
    
   
    private override init () {
        super.init()
        requestLocationPermission()
    }
    
    public func requestLocationPermission() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            if let manager = locationManager {
                manager.delegate = self
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
                //manager.allowsBackgroundLocationUpdates = true
                manager.pausesLocationUpdatesAutomatically = false
            }
        }
    }
    
    public func startScanning() {
        updateLocation(true)
        
        beaconRegion.forEach { region in
            startMonitoring(region)
        }
       
        TSBeaconManager.shared.initializeBeaconObserver()
    }
    
    public func stopScanning() {
        updateLocation(false)
        
        beaconRegion.forEach { region in
            stopMonitoring(region)
        }
    }
    
    private func updateLocation(_ start: Bool) {
        guard let manager = locationManager else {
            print("=====Location Manager NIL======")
            return
        }
        
        if start {
            print("=====Location Manager Start Updating======")
            manager.startUpdatingLocation()
            
            beaconRegion.forEach { region in
                startMonitoring(region)
            }
            
        } else {
            print("=====Location Manager Stop Updating======")
            beaconRegion.forEach { region in
                stopMonitoring(region)
            }
            
            manager.stopUpdatingLocation()
        }
    }
    
    private func startMonitoring(_ beaconRegion: CLBeaconRegion) {
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    private func stopMonitoring(_ beaconRegion: CLBeaconRegion) {
        if let authorizationStatus = self.authorizationStatus {
            if authorizationStatus != .authorizedAlways && authorizationStatus != .authorizedWhenInUse {
                locationManager?.stopMonitoring(for: beaconRegion)
                locationManager?.stopRangingBeacons(in: beaconRegion)
            }
        }
        
    }
    
    public func observeBeaconRanged(completion: @escaping((Notification)) -> Void) -> NSObjectProtocol {
        
        return NotificationCenter.default.addObserver(forName: Notification.Name(beaconRangeNotificationName), object: nil, queue: nil) { (notification) in
            
            completion(notification)
        }
    }
    
    // MARK: - CLLocationManagerDelegateb
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        NotificationCenter.default.post(name: Notification.Name(beaconRangeNotificationName), object: beacons)
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Location update failed
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.exitedRegion.rawValue), object: nil, userInfo: ["region": region])
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.enterRegion.rawValue), object: nil, userInfo: ["region": region])
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        if status == .authorizedAlways || status ==  .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
}
