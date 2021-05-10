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
    case badResponse(URLResponse?)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let decoder = JSONDecoder()
    
    private var imageCache = NSCache<NSString, NSData>()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    public func loadSingleObject<T: Codable>(with route: Route, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = route.url else {
            completion(.failure(APIError.badURL))
            return
        }
        let request = createRequest(with: url, type: route.method)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.badResponse(response)))
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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.badResponse(response)))
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
    
    public func downloadAnImage(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        if let imageData = imageCache.object(forKey: imageURL.absoluteString as NSString) {
          completion(imageData as Data, nil)
          return
        }
        
        let task = URLSession.shared.downloadTask(with: imageURL) { localUrl, response, error in
          if let error = error {
            completion(nil, error)
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(nil, APIError.badResponse(response))
            return
          }
          
          guard let localUrl = localUrl else {
            completion(nil, APIError.badURL)
            return
          }
          
          do {
            let data = try Data(contentsOf: localUrl)
            self.imageCache.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
            completion(data, nil)
          } catch {
            completion(nil, error)
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
            request.setValue("Client-ID \(Constants.clientID)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        return request
    }
    
}
