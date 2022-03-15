//
//  BeaconServices.swift
//  Pods-TSRTLS_Example
//
//  Created by Steeven Sylveus on 1/30/22.
//

import Foundation

struct Authorization: Codable {
    var jwt: String?
}

struct Credentials {
    static var jwt: String?
    static var apiId: String?
    static var clientSecret = "A3s6v9y$B&E)H@McQfTjWnZr4u7w!z%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPeSh"
    
}

struct API {
    static let authURL = "https://authprovider-d-us-c-api.azurewebsites.net/"
    static let RTLSBaseURL = "https://rtls-d-us-c-api.azurewebsites.net/"
    
    struct Endpoints {
        static let authorization = "api/api-authorizations"
        static let trackingDevices = "api/tracking-devices"
        static let applications = "applications"
    }
}

struct BeaconServices {
    
    func authenticate() {
        WebService()
            .setURL(url: API.authURL)
            .setHeaders(headers: [
                "Authorization": "Basic \(Credentials.clientSecret)"
            ])
            .setPath(path: API.Endpoints.authorization)
            .addParmeters(params: [
                "apiId": Credentials.apiId ?? ""
            ])
            .setMethod(method: .post)
            .build(type: Authorization.self) { responseBody, responseHeader, error in
                if let response = responseBody as? Authorization {
                    Credentials.jwt = response.jwt
                }
            }
    }
    
    func getAppinfo(appID: String) {
        
    }
    
    func getTrackingDevices(completion: @escaping(_ devices: [String], _ error: Error?) -> Void) {
        
        WebService()
            .setPath(path: API.Endpoints.trackingDevices)
            .build(type: [String].self) { responseBody, responseHeader, error in
                completion(responseBody as? [String] ?? [], error)
            }
    }
    
    func getDeviceInfo(deviceID: String, completion: @escaping(_ device: TSDevice?, _ error: Error?) -> Void) {
        
        WebService()
            .setPath(path: API.Endpoints.trackingDevices + "/\(deviceID)/locations")
            .build(type: TSDevice.Location.self) { responseBody, responseHeader, error in
                let location = (responseBody as? [TSDevice.Location])?.first
                
                WebService()
                    .setPath(path: API.Endpoints.trackingDevices + "/\(deviceID)")
                    .build(type: TSDevice.self) { responseBody, responseHeader, error in
                        var device = responseBody as? TSDevice
                        device?.location = location
                        completion(device, error)
                    }
            }
        
        
    }
    
    func getBeaconIdentifier(_ beaconData: [[String: Any]], completion: @escaping (_ beacons: [[String: Any]], _ error: Error?)->()) {
        
        WebService()
            .setPath(path: Endpoints.beaconUIDConversion.rawValue)
            .setMethod(method: .post)
            .setBody(body: beaconData)
            .build { (responseBody, responseHeader, error) in
                if let body = responseBody as? [[String: Any]] {
                    completion(body, error)
                } else {
                    completion([], error)
                }
                
            }
    }
    
}
