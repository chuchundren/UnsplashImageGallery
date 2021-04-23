//
//  AuthManager.swift
//  Unsplash
//
//  Created by Дарья on 14.04.2021.
//

import Foundation


class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "lSXj4TBY1EdaoE5GriAhHAAsfPalz5G7RBofQdLYlbY"
        static let clientSecret = "_hcFhxwFalfEkrSzqLJrXt6QM5zVP_2Z9SNCwokqckU"
        static let tokenAPIURL = "https://unsplash.com/oauth/token"
        static let scopes = ["public", "read_user", "write_user", "read_photos", "write_photos", "write_likes", "write_followers", "read_collections", "write_collections"].joined(separator: "+")
    }
    
    public var signInURL: URL? {
        let base = "https://unsplash.com/oauth/authorize"
        let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        let string = "\(base)?client_id=\(AuthManager.Constants.clientID)&redirect_uri=\(redirectURI)&response_type=code&scope=\(Constants.scopes)"
        return URL(string: string)
    }
    
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    public func requestToken(for code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "urn:ietf:wg:oauth:2.0:oob"),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "client_secret", value: Constants.clientSecret)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
    }
}
