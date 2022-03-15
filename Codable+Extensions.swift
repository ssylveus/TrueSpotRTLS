//
//  Codable+Extensions.swift
//  Pods-TSRTLS_Example
//
//  Created by Steeven Sylveus on 2/3/22.
//

import Foundation

extension Decodable {
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
    
    static func decode(from object: Any) throws -> Self {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            throw NSError(domain: "Invalid JSON Format", code: -1, userInfo: nil)
        }
        return try decode(data: data)
    }

}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    func toJSON() -> Any? {
        if let data = try? JSONEncoder().encode(self) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func toJSONString() -> String? {
        do {
            let data =  try encode()
            return String(data: data, encoding: .utf8)
        } catch  {
            return nil
        }
    }
}
