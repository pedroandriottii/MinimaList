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
    
    func getAllClients(callback: @escaping (Result<[Client], Error>) -> Void) {
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
                let clients = try JSONDecoder().decode([Client].self, from: data)
                callback(.success(clients))
            } catch {
                callback(.failure(ServiceError.decoding(error)))
            }
        }
        
        task.resume()
    }
    
    func createClient(client: Client, callback: @escaping (Result<Void, Error>) -> Void) {
        let path = "/clients"
        guard let url = URL(string: baseURL + path) else {
            callback(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(client)
            request.httpBody = jsonData
        } catch {
            callback(.failure(ServiceError.encoding(error)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                callback(.failure(ServiceError.network(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                callback(.failure(ServiceError.network(nil)))
                return
            }
            
            callback(.success(()))
        }
        
        task.resume()
    }
}
