//
//  NetworkManager.swift
//  Pexels
//
//  Created by Дарья on 02.04.2021.
//

import Foundation


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let decoder = JSONDecoder()
    
    enum HTTPMethod: String {
        case POST
        case GET
        case DELETE
    }
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    private let apiKey = "lSXj4TBY1EdaoE5GriAhHAAsfPalz5G7RBofQdLYlbY"
    private let baseURL = "https://api.unsplash.com"
    
    public func getListPhotos(completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "https://api.unsplash.com/photos/?per_page=30"), type: .GET) else { return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try self.decoder.decode([UnsplashPhoto].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    public func getSearchedPhotos(for searchText: String, completion: @escaping (Result<SearchedPhotosResponse, Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "\(baseURL)/search/photos/?query=\(searchText)"), type: .GET) else { return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try self.decoder.decode(SearchedPhotosResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getPhoto(id: String, completion:@escaping (Result<UnsplashPhoto, Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "\(baseURL)/photos/\(id)"), type: .GET) else { return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try self.decoder.decode(UnsplashPhoto.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getUserProfile(_ username: String, completion: @escaping (Result<UnsplashUser, Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "https://api.unsplash.com/users/\(username)"), type: .GET) else { return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try self.decoder.decode(UnsplashUser.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<CurrentUserPrivateProfile, Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "\(baseURL)/me"), type: .GET) else { return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try self.decoder.decode(CurrentUserPrivateProfile.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getUsersPhotos(_ username: String, completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void) {
        
    }
    
    public func getUsersLikedPhotos(_ username: String, completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "https://api.unsplash.com/users/\(username)/likes"), type: .GET) else { return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try self.decoder.decode([UnsplashPhoto].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // FIXME: - not every photo is liked, I get an error more often, probably because of the reques body. Also, I'm not quite sure if I need completion block in uploadTask at all
    public func likePhoto(id: String, completion: @escaping (Result<LikeResponse, Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "\(baseURL)/photos/\(id)/like"), type: .POST) else {
            return
        }
        let jsonBody = ["id": id]
        let body = try? JSONSerialization.data(withJSONObject: jsonBody, options: .fragmentsAllowed)
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try self.decoder.decode(LikeResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // TODO: - create delete request to unlike a photo
    public func unlikePhoto(id: String, completion: @escaping (Result<LikeResponse, Error>) -> Void) {
        guard let request = createRequest(with: URL(string: "\(baseURL)/photos/\(id)/like"), type: .DELETE) else {
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                completion(.failure(error as! Error))
                return
            }
            print(response)
            print("DATA IS: \(data)")
            do {
                let result = try self.decoder.decode(LikeResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod) -> URLRequest? {
        guard let apiURL = url else { return nil }
        
        var request = URLRequest(url: apiURL)
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
