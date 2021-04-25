//
//  CurrentUserPrivateProfile.swift
//  Unsplash
//
//  Created by Дарья on 15.04.2021.
//

import Foundation

struct CurrentUserPrivateProfile: Codable {
    let id: String
    let username: String
    let firstName: String?
    let lastName: String?
    let portfolioUrl: String?
    let bio: String?
    let location: String?
    let totalLikes: Int
    let totalPhotos: Int
    let followedByUser: Bool
    let email: String
    let links: UserLinks
    let profileImage: ProfileImage
}

struct UserLinks: Codable {
    let photos: String
    let likes: String
    let portfolio: String
}
