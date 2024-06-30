//
//  Service.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 29/06/24.
//

import UIKit

struct Client: Codable {
    let id: Int
    let name: String
    let street: String
    let number: String
    let neighborhood: String
    let complement: String?
}

enum ServiceError: Error {
    case invalidURL
    case network(Error?)
}

class Service {
    
    private let baseURL = "https://reasonable-amazement-production.up.railway.app"
    
    func get(callback: @escaping (Result<[Client], Error>) -> Void) {
        
        let path = "/clients"
        guard let url = URL(string: baseURL + path) else {
            callback(.failure(ServiceError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                callback(.failure(ServiceError.network(error)))
                return
            }
            
            guard let data = data else {
                callback(.failure(ServiceError.network(nil)))
                return
            }
            
            do {
                let json = try JSONDecoder().decode([Client].self, from: data)
                
                callback(.success(json))
            } catch {
                callback(.failure(error))
            }
        }
        task.resume()
    }
}

