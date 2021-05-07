//
//  Request.swift
//  Unsplash
//
//  Created by Дарья on 29.04.2021.
//

import Foundation

protocol RouteProvider {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

enum Route {
    case listPhotos
    case searchedPhotos(searchText: String)
    case photo(id: String)
    case user(username: String)
    case currentUser
    case usersPhotos(username: String)
    case usersLikedPhotos(username: String)
    case likePhoto(id: String)
    case unlikePhoto(id: String)
}

extension Route: RouteProvider {
    var baseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Wrong base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .listPhotos:
            return "/photos/?per_page=30"
        case .searchedPhotos(let searchText):
            return "/search/photos/?query=\(searchText)"
        case .photo(let id):
            return "/photos/\(id)"
        case .user(let username):
            return "/users/\(username)"
        case .currentUser:
            return "/me"
        case .usersPhotos(let username):
            return "/users/\(username)/photos?per_page=30"
        case .usersLikedPhotos(let username):
            return "/users/\(username)/likes?per_page=30"
        case .likePhoto(let id):
            return "/photos/\(id)/like"
        case .unlikePhoto(let id):
            return "/photos/\(id)/like"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethod {
        switch self {
        case .likePhoto:
            return .POST
        case .unlikePhoto:
            return .DELETE
        default:
            return .GET
        }
    }
    
}
