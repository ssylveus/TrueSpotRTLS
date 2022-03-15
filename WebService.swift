//
//  WebService.swift
//  Pods-TSRTLS_Example
//
//  Created by Steeven Sylveus on 1/30/22.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

fileprivate struct OptionalCodable: Codable {
    //Use to be able to pass nil
}

class WebService {
    
    
    typealias CompletionHandler = (_ responseBody: Any?, _ responseHeader: URLResponse?, _ error: Error?) -> Void
    
    private var url: String = ""
    private var params = [String: String]()
    private var headers = [String: String]()
    private var method: HTTPMethod = .get
    private var body: Data?
    private var path: String = ""
    
    /// The base URL of the request
    /// - Parameter url: The web service url
    func setURL(url: String = API.RTLSBaseURL) -> WebService {
        self.url = url
        return self
    }
    
    /// Takes a collection of parameters and for appending to request url.
    /// - Parameter params: list of parameters to add
    func addParmeters(params: [String: String]) -> WebService {
        self.params = params
        return self
    }
    
    func setHeaders(headers: [String: String] = [:]) -> WebService {
        self.headers = headers
        
        if headers["Content-Type"] == nil {
            self.headers["Content-Type"] = "application/json"
        }
        
        if let jwt = Credentials.jwt {
            self.headers["Authorization"] = "Bearer \(jwt)"
        }
        
        return self
    }
    
    func setMethod(method: HTTPMethod) -> WebService {
        self.method = method
        return self
    }
    
    func setPath(path: String) -> WebService {
        self.path = path
        return self
    }
    
    func setBody<T:Encodable>(body: T) -> WebService {
        self.body = try? body.encode()
        return self
        
    }
    
    func setBody(body: Any) -> WebService {
        if let data = body as? Data {
            self.body = data
        } else {
            self.body = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        return self
    }
    
    func createRequest() -> URLRequest? {
        if self.url == "" {
            _ = setURL()
        }
        url += self.path
        
        guard var baseURL = URL(string: self.url) else {
            return nil
        }
        
        for (key, value) in params {
            baseURL = baseURL.appending(key, value: value)
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = self.method.rawValue
        
        if self.headers.count == 0 {
            _ = self.setHeaders()
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = self.body
        
        return request
    }
    /// Creates a request and parse it to a Codable comformer
    /// - Parameters:
    ///   - type: the class type to parse the response to
    ///   - completion: the closure callback for response and error
    func build<T: Codable>(type: T.Type, completion: @escaping CompletionHandler) {
        
        guard let request = createRequest() else {
            return
        }
        
        makeRequest(request, type, completion)
    }
    
    func build(completion: @escaping CompletionHandler) {
        
        guard let request = createRequest() else {
            return
        }
        
        makeRequest(request, OptionalCodable.self, completion)
    }
    
    private func makeRequest<T: Codable>(_ request: URLRequest, _ type: T.Type?, _ completion: @escaping CompletionHandler) {
        let session = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask?
        
        dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            self.processResponse(type, request, data, response, error, completion: completion)
        })
        
        dataTask?.resume()
    }
    
    private func processResponse<T: Codable>(_ type: T.Type?, _ request: URLRequest, _ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping CompletionHandler) {
        DispatchQueue.main.async {
            if let data = data, let response = response as? HTTPURLResponse {
                
                if response.statusCode == 200 {
                    if let mapType = type, mapType != OptionalCodable.self {
                        do {
                            let decoder  = JSONDecoder()
                            let codable = try decoder.decode(mapType, from: data)
                    
                            
                            let rawResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            self.printRequestInfo(request: request, response: rawResponse)
                            completion(codable, response, nil)
                        } catch {
                            completion(nil, response, error)
                        }
                    } else {
                        do {
                            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                            
                            self.printRequestInfo(request: request, response: jsonResponse)
                            completion(jsonResponse, response, nil)
                        } catch {
                            self.printRequestInfo(request: request, response: response)
                            if response.statusCode == 200 {
                                completion(nil, response, nil)
                            } else {
                                completion(nil, response, error)
                            }
                        }
                        
                        
                    }
                    
                } else if response.statusCode == 401 {
                    
//                    AuthenticateService.renewCredentials(success: {
//                        self.makeRequest(request, type, completion)
//                    }, failure: {
//                        completion(nil, response, error)
//                        User.logout()
//                    })
                    self.printRequestInfo(request: request, response: response)
                    
                } else {
                    self.printRequestInfo(request: request, response: response)
                    completion(nil, response, error)
                }
                
            } else {
                self.printRequestInfo(request: request, response: response)
                completion(nil, response, error)
            }
        }
    }
    
    private func printRequestInfo(request: URLRequest, response: Any?) {
        if TrueSpot.isDebugMode {
            print("HttpMethod: \(String(describing: request.httpMethod))")
            print("*****URL: \n\(String(describing: request.url?.absoluteURL))*****")
            print("*****Headers: \n\(String(describing: request.allHTTPHeaderFields))*****")
            print("*****Request Body: \n\(String(describing: self.body?.toJSONObject))*****")
            print("*****Response******")
            print(response as Any)
            print("\n\n")
        }
    }
}
