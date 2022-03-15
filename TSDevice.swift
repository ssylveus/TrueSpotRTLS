//
//  Device.swift
//  TSRTLS
//
//  Created by Steeven Sylveus on 3/13/22.
//

import Foundation

public struct TSDevice: Codable {
    
    public struct Location: Codable {
        public var id: String?
        public var assetIdentifier: String?
        public var assetType: String?
        public var latitude: Double?
        public var longitude: Double?
        public var level: Int?
        public var accuracy: Double?
        public var zoneId: String?
        public var zoneName: String?
        public var placeId: String?
        public var placeName: String?
        public var placeCategoryId: String?
        public var placeCategoryName: String?
        public var localeId: String?
        public var localeName: String?
        public var sourceDeviceNames: [String]? = [String]()
        public var timestamp: String?
    }
    
    
    public var tagIdentifier: String?
    public var assetIdentifier: String?
    public var assetType: String
    public var batteryLevel: Int?
    public var pairedOnTimestamp: String?
    public var pairedByUsername: String?
    public var location: Location?
}
