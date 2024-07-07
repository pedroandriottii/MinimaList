//
//  APIHelper.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 01/07/24.
//

import Foundation

enum RequestType {
    case get
    case post
    case put
}

struct APIResponseError: Codable {
    var code: Int?
    var message: String
    
    enum CodingKeys: String, CodingKey{
        case code = "statusCode"
        case message = "message"
    }
}

final class APIHelper {
    
    static func request<T:Decodable>(method: RequestType,
                                     endpoint: String,
                                     parameters: Dictionary<String, Any>,
                                     responseType: T.Type,
                                     completion: @escaping (_ response: T?,
                                                            _ error: APIResponseError?,
                                                            _ code: Int) -> Void) {
        
        var serverURL: String = "https://reasonable-amazement-production.up.railway.app" + endpoint
        
        let request = NSMutableURLRequest()
        request.timeoutInterval = 30
        request.cachePolicy = .useProtocolCachePolicy
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        switch method {
            case .get:
                serverURL += parameters.buildQueryString()
                request.httpMethod = "GET"
                break
            case .post:
                request.httpMethod = "POST"
                let jsonData = try? JSONEncoder().encode(parameters["client"] as! Client)
                request.httpBody = jsonData
                break
            case .put:
                request.httpMethod = "PUT"
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                break
        }
        
//        if let token = Session.get()?.token {
//            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        }
        
        request.url = URL(string: serverURL)
        
        //---------------------------------------------------------
        //  Load API
        //---------------------------------------------------------
        
        DispatchQueue.global().async {
            let _ = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                let responseCode = response?.getStatusCode() ?? 0
                if let data = data, data.count != 0 {
                    let responseError = try? JSONDecoder().decode(APIResponseError.self, from: data)
                    if responseCode == 201 {
                        DispatchQueue.main.async{
                            completion(nil, nil, responseCode)
                            return
                        }
                    }
                    do {
                        let parse = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(parse, responseError, responseCode)
                        }
                    }catch{
                        DispatchQueue.main.async {
                            completion(nil, responseError, responseCode)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(nil, nil, responseCode)
                    }
                }
            }).resume()
        }
    }
}

