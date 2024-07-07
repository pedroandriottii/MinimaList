//
//  Service.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 29/06/24.
//

import UIKit

struct Client: Codable {
    let id: Int?
    let name: String
    let street: String
    let number: String
    let neighborhood: String
    let complement: String?
}

enum ServiceError: Error {
    case invalidURL
    case network(Error?)
    case decoding(Error)
    case encoding(Error)
}

class Service {
    
    private let baseURL = "https://reasonable-amazement-production.up.railway.app"
    
    func getAllClients(_ completion: @escaping(_ result: [Client]?, _ error: APIResponseError?) -> Void) {
        APIHelper.request(method: .get, endpoint: "/clients", parameters: [:], responseType: [Client].self) { response, error, code in
            if code == 200 {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func create(client: Client, _ completion: @escaping(_ success: Bool,_ error: APIResponseError?) -> Void){
        
        APIHelper.request(method: .post, endpoint: "/clients", parameters: ["client": client], responseType: Bool.self) { response,error,code in
            if code == 201 {
                completion(true, nil)
            } else{
                completion(false, error)
            }
        }
    }

}
