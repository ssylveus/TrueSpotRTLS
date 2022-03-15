//
//  Beacon.swift
//  Pods-TSRTLS_Example
//
//  Created by Steeven Sylveus on 1/30/22.
//

import UIKit
import CoreLocation

public class TSBeacon {
    public var beaconId: String?
    public var name: String?
    public var description: String?
    public var beaconIdentifier: String?
    public var isActive: Bool?
    public var vin: String?
    public var lat: Double?
    public var lng: Double?
    public var timeStamp: TimeInterval?
    public var RSSI: Int?
    public var accuracy: Double?
    public var major: String?
    public var minor: String?
    public var proximity: CLProximity = .unknown
    
    init(json: [String: Any]) {
        beaconId = json["beaconId"] as? String
        name = json["name"] as? String
        description = json["description"] as? String
        beaconIdentifier = json["beaconIdentifier"] as? String
        isActive = json["isActive"] as? Bool
        vin = json["vin"] as? String
        lat = json["lat"] as? Double
        lng = json["lng"] as? Double
    }
    
    init(beacon: CLBeacon, currentLocation: CLLocation? = nil) {
        self.lat = currentLocation?.coordinate.latitude ?? 0
        self.lng = currentLocation?.coordinate.longitude ?? 0
        
        self.RSSI = beacon.rssi
        self.beaconIdentifier = ""
        self.accuracy = currentLocation?.horizontalAccuracy ?? 0
        self.beaconId =  beacon.proximityUUID.uuidString.replacingOccurrences(of: "-", with: "")
        self.major = beacon.major.stringValue
        self.minor = beacon.minor.stringValue
        self.timeStamp = Date().timeIntervalSince1970
        self.proximity = beacon.proximity
    }
    
    init(beaconIdentifier: String) {
        self.beaconIdentifier = beaconIdentifier
    }
    
    init(data: [String: Any]) {
        beaconIdentifier = data["beaconIdentifier"] as? String
        timeStamp = data["timeStamp"] as? TimeInterval
        lat = data["lat"] as? Double
        lng = data["lng"] as? Double
        RSSI = data["rssi"] as? Int
        accuracy = data["accuracy"] as? Double
        beaconId = data["uuid"] as? String
        major = data["major"] as? String
        minor = data["minor"] as? String
    }
    
    func alreadyAssigned() -> Bool {
        if (vin != nil) {
            return true
        } else {
            return false
        }
    }
    
    func toString() -> String {
   
        let keys = ["Beacon ID", "TimeStamp", "Lat", "Long", "RSSI", "Acuracy", "UUID", "Minor", "Major"]
        
        
        let values: [Any?] = [beaconIdentifier,
                              Date(timeIntervalSince1970: timeStamp ?? 0).stringDate,
                              lat,
                              lng,
                              RSSI,
                              accuracy,
                              beaconId,
                              minor,
                              major]
        
        var formattedString = ""
        for i in 0..<keys.count {
            formattedString += "\(keys[i]): \(values[i] ?? "")\n"
        }
        
        return formattedString
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "lat": lat ?? 0,
            "lng": lng ?? 0,
            "rssi" : RSSI ?? 0,
            "beaconIdentifier": beaconIdentifier ?? "",
            "accuracy": accuracy ?? 0,
            "batteryLevel": "",
            "uuid": beaconIdentifier ?? "",
            "major": major ?? "",
            "minor": minor ?? "",
            "timeStamp": timeStamp ?? 0
        ]
    }
}
