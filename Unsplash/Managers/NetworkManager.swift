//
//  NetworkManager.swift
//  Pexels
//
//  Created by Дарья on 02.04.2021.
//

import Foundation

enum HTTPMethod: String {
    case POST
    case GET
    case DELETE
}

enum APIError: Error {
    case badURL
    case failedToGetData
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    private let apiKey = "lSXj4TBY1EdaoE5GriAhHAAsfPalz5G7RBofQdLYlbY"
    private let baseURL = "https://api.unsplash.com"
    
    public func loadSingleObject<T: Codable>(with route: Route, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = route.url else {
            completion(.failure(APIError.badURL))
            return
        }
        let request = createRequest(with: url, type: route.method)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func loadAnArray<T: Codable>(with route: Route, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let url = route.url else {
            completion(.failure(APIError.badURL))
            return
        }
        let request = createRequest(with: url, type: route.method)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try self.decoder.decode([T].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func createRequest(with url: URL, type: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        
        if let token = AuthManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        return request
    }
    
}
