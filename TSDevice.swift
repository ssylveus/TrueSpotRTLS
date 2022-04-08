//
//  Device.swift
//  TSRTLS
//
//  Created by Steeven Sylveus on 3/13/22.
//

import Foundation

public struct TSDevice: Codable {
    public var tagIdentifier: String?
    public var assetIdentifier: String?
    public var assetIdentifierB: String?
    public var assetType: String
    public var batteryLevel: Int?
    public var pairedOnTimestamp: String?
    public var pairedByUsername: String?
    public var locationUpdateTimestamp: String?
    public var latitude: Double?
    public var longitude: Double?
    public var level: Int?
    public var accuracy: Double?
    public var subGeoZone: String?
    public var zoneId: String?
    public var zoneName: String?
    public var placeId: String?
    public var placeName: String?
    public var placeCategoryId: String?
    public var placeCategoryName: String?
    public var localeId: String?
    public var localeName: String?
    public var uuid: String?
    public var major: String?
    public var minor: String?
    public var sourceDeviceNames: [String]? = [String]()
}
