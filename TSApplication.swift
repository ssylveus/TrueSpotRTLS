//
//  TSApplication.swift
//  TSRTLS
//
//  Created by Steeven Sylveus on 4/7/22.
//

import Foundation

struct TSApplication: Codable {
    var id: String?
    var name: String?
    var description: String?
    var uuids: [String]? = [String]()
}
