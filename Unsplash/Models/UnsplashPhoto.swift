//
//  UnsplashPhoto.swift
//  Unsplash
//
//  Created by Дарья on 10.04.2021.
//

import Foundation

struct SearchedPhotosResponse: Codable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Codable {
    let id: String
    let width: Int
    let height: Int
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: Urls
    let user: UnsplashUser
    let createdAt: Date
//    let location: PhotoLocation?
//    let tags: [String: String]
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct UnsplashUser: Codable {
    let id: String
    let username: String
    let name: String
    let bio: String?
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct PhotoLocation: Codable {
    let city: String?
    let country: String?
}


struct SinglePhoto: Codable {
    let id: String
    let width: Int
    let height: Int
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: Urls
    let user: UnsplashUser
    let location: PhotoLocation?
    let createdAt: Date
//    let tags: [String: String]
}
