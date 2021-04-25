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
    let user: UnsplashUser?
    let location: PhotoLocation?
    let createdAt: Date
    //let tags: [String: String]?
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

/*
 {
     photo =     {
         "alt_description" = "brown bread on white ceramic plate";
         "blur_hash" = "LMNTavE1?wn$Dia}RPWB%hof4TNG";
         categories =         (
         );
         color = "#d9d9d9";
         "created_at" = "2021-04-24T15:06:47-04:00";
         "current_user_collections" =         (
         );
         description = "<null>";
         height = 5510;
         id = I3IQBuM9bXs;
         "liked_by_user" = 1;
         likes = 2;
         links =         {
             download = "https://unsplash.com/photos/I3IQBuM9bXs/download";
             "download_location" = "https://api.unsplash.com/photos/I3IQBuM9bXs/download";
             html = "https://unsplash.com/photos/I3IQBuM9bXs";
             self = "https://api.unsplash.com/photos/I3IQBuM9bXs";
         };
         "promoted_at" = "2021-04-24T15:24:01-04:00";
         sponsorship = "<null>";
         "updated_at" = "2021-04-24T15:31:07-04:00";
         urls =         {
             full = "https://images.unsplash.com/photo-1619291164324-78566752ecca?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb";
             raw = "https://images.unsplash.com/photo-1619291164324-78566752ecca?ixlib=rb-1.2.1";
             regular = "https://images.unsplash.com/photo-1619291164324-78566752ecca?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max";
             small = "https://images.unsplash.com/photo-1619291164324-78566752ecca?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max";
             thumb = "https://images.unsplash.com/photo-1619291164324-78566752ecca?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max";
         };
         width = 3392;
     };
     user =     {
         "accepted_tos" = 0;
         bio = "Junior iOS Developer. Currently using Unsplash API for a pet project. ";
         "first_name" = Dasha;
         "for_hire" = 0;
         id = 50dtZeMKF7o;
         "instagram_username" = "<null>";
         "last_name" = "<null>";
         links =         {
             followers = "https://api.unsplash.com/users/chuchundren/followers";
             following = "https://api.unsplash.com/users/chuchundren/following";
             html = "https://unsplash.com/@chuchundren";
             likes = "https://api.unsplash.com/users/chuchundren/likes";
             photos = "https://api.unsplash.com/users/chuchundren/photos";
             portfolio = "https://api.unsplash.com/users/chuchundren/portfolio";
             self = "https://api.unsplash.com/users/chuchundren";
         };
         location = "Saint Petersburg, Russia";
         name = Dasha;
         "portfolio_url" = "<null>";
         "profile_image" =         {
             large = "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128";
             medium = "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64";
             small = "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32";
         };
         "total_collections" = 0;
         "total_likes" = 0;
         "total_photos" = 0;
         "twitter_username" = "<null>";
         "updated_at" = "2021-04-16T08:46:13-04:00";
         username = chuchundren;
     };
 }

 */
