//
//  Bundle+Extensions.swift
//  TSRTLS
//
//  Created by Steeven Sylveus on 3/13/22.
//

import Foundation

public extension Bundle {
    static var trueSpotBundle: Bundle {
        return Bundle(for: TSLocationManager.self)
    }
}
