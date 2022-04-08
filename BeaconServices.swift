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
    static var appID: String?
    static var clientSecret: String?
    static var appInfo: TSApplication?
    static var apiID = "5eacf68e333c811bb1ec3e7d"
}

struct API {
    //DEV
    static let authURL = "https://authprovider-d-us-c-api.azurewebsites.net/"
    
    //PROD
    //static let authURL = "https://auth.truespot.com/"
    
    //DEV
    static let RTLSBaseURL = "https://rtls-d-us-c-api.azurewebsites.net/"
    
    //PROD
    //static let RTLSBaseURL = "https://rtls.truespot.com/"
    
    struct Endpoints {
        static let authorization = "api/api-authorizations"
        static let trackingDevices = "api/tracking-devices"
        static let applications = "applications"
    }
}

struct BeaconServices {
    
    func authenticate() {
        
        guard let secret = Credentials.clientSecret else {
            return
        }
        
        WebService()
            .setURL(url: API.authURL)
            .setHeaders(headers: [
                "Authorization": "Basic \(secret)"
            ])
            .setPath(path: API.Endpoints.authorization)
            .addParmeters(params: [
                "apiId": Credentials.apiID
            ])
            .setMethod(method: .post)
            .build(type: Authorization.self) { responseBody, responseHeader, error in
                if let response = responseBody as? Authorization {
                    Credentials.jwt = response.jwt
                    self.getAppinfo(appID: Credentials.appID ?? "")
                    self.getTrackingDevices { devices, error in
                        
                    }
                }
            }
    }
    
    func getAppinfo(appID: String) {
        if appID.isEmpty {
            return
        }
        
        WebService()
            .setPath(path: API.Endpoints.applications + "/\(appID)")
            .build(type: TSApplication.self) { responseBody, responseHeader, error in
                //Credentials.appInfo = responseBody as? TSApplication
                
                TSLocationManager.shared.startScanning()
            }
    }
    
    func getTrackingDevices(completion: @escaping(_ devices: [TSDevice], _ error: Error?) -> Void) {
        
//        WebService()
//            .setPath(path: API.Endpoints.trackingDevices)
//            .build(type: [TSDevice].self) { responseBody, responseHeader, error in
//
//                let devices = responseBody as? [TSDevice] ?? []
//                TSBeaconManager.shared.updateTrackingDevices(devices: devices)
//                completion(devices, error)
//            }
        
        WebService()
            .setURL(url: "https://mocki.io/")
            .setPath(path: "v1/619ced0c-3c97-4dbc-9826-db0e26df7dce")
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
            .setBody(body: ["assetdentifier": assetIdentifier, "assetType": assetType])
            .build(type: TSDevice.self) { responseBody, responseHeader, error in
                
                completion(responseBody as? TSDevice, error)
            }
    }
}
