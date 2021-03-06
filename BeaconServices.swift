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
    static var clientSecret: String?
    static var appInfo: TSApplication?
    static var tenantId: String?
}

enum TSEnvironment {
    case dev
    case prod
    
    var authURL: String {
        switch self {
            
        case .dev:
            return "https://authprovider-d-us-c-api.azurewebsites.net/"
        case .prod:
            return "https://auth.truespot.com/"
        }
    }
    
    var baseURL: String {
        switch self {
            
        case .dev:
            return "https://rtls-d-us-c-api.azurewebsites.net/"
        case .prod:
            return "https://rtls.truespot.com/"
        }
    }
}

struct API {
    static let environment: TSEnvironment = .dev
    
    static let authURL = environment.authURL

    static let RTLSBaseURL = environment.baseURL
    
    struct Endpoints {
        static let authorization = "api/api-authorizations"
        static let trackingDevices = "api/tracking-devices"
        static let applications = "api/applications"
    }
}

struct BeaconServices {
    
    func authenticate() {
        
        guard let secret = Credentials.clientSecret, let tenantId = Credentials.tenantId else {
            return
        }
        
        WebService()
            .setURL(url: API.authURL)
            .setHeaders(headers: [
                "Authorization": "Basic \(secret)"
            ])
            .setPath(path: API.Endpoints.authorization)
            .addParmeters(params: [
                "tenantId": tenantId
            ])
            .setMethod(method: .post)
            .build(type: Authorization.self) { responseBody, responseHeader, error in
                if let response = responseBody as? Authorization {
                    Credentials.jwt = response.jwt
                    self.getAppinfo()
                    self.getTrackingDevices { devices, error in
                        
                    }
                }
            }
    }
    
    func getAppinfo() {
        
        WebService()
            .setPath(path: API.Endpoints.applications + "?self")
            .build(type: TSApplication.self) { responseBody, responseHeader, error in
                
                Credentials.appInfo = responseBody as? TSApplication
                
                TSLocationManager.shared.startScanning()
            }
    }
    
    func getTrackingDevices(completion: @escaping(_ devices: [TSDevice], _ error: Error?) -> Void) {
        
        WebService()
            .setPath(path: API.Endpoints.trackingDevices)
            .build(type: [TSDevice].self) { responseBody, responseHeader, error in

                let devices = responseBody as? [TSDevice] ?? []
                TSBeaconManager.shared.updateTrackingDevices(devices: devices)
                completion(devices, error)
            }
    }
    
    func pair(assetIdentifier: String, assetType: String, tagId: String, completion: @escaping (_ device: TSDevice?, _ error: Error?) -> Void) {
        
        WebService()
            .setPath(path: API.Endpoints.trackingDevices + "/\(tagId)/pairings")
            .setMethod(method: .post)
            .setBody(body: ["assetIdentifier": assetIdentifier, "assetType": assetType])
            .build(type: TSDevice.self) { responseBody, responseHeader, error in
                
                completion(responseBody as? TSDevice, error)
            }
    }
    
    func unpair(deviceID: String, pairingId: String, completion: @escaping (_ error: Error?) -> Void) {
        WebService()
            .setPath(path: API.Endpoints.trackingDevices + "/\(deviceID)/pairings/\(pairingId)")
            .setMethod(method: .delete).build { responseBody, responseHeader, error in
                completion(error)
            }
    }
}
