//
//  Data+Extensions.swift
//  TrueSpot
//
//  Created by Steeven Sylveus on 9/1/20.
//  Copyright © 2020 TrueSpot. All rights reserved.
//

import Foundation

extension Data {
    var toJSONObject: Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            return json
        } catch {
            return nil
        }
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

