//
//  PairResponse.swift
//  Pods-TSRTLS_Example
//
//  Created by Steeven Sylveus on 1/30/22.
//

import Foundation

struct PairResponse: Codable {
    
    enum PairCode: String, Codable {
        case noChange = "no_change"
        case trackerNotFound = "tracker_not_found"
        case trackerInUse = "tracker_in_use"
    }
    
    var code: PairCode?
    var message: String?
    var overwritable: Bool?
    var vehicleId: String?
    var success: Bool?
    var previousVehicleId: String?
}
