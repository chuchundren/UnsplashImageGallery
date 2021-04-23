//
//  PhotoObject.swift
//  Pexels
//
//  Created by Дарья on 02.04.2021.
//

import Foundation

struct PhotoResponse: Codable {
    let photos: [PhotoObject]
}

struct PhotoObject: Codable {
    let id: Int
    let url: String
    let photographer: String
    let photographer_url: String
    let photographer_id: Int
    let src: Src
    let width: Int
    let height: Int
}

struct Src: Codable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}

enum SRC {
    case original, large2x, large, medium, small, portrait, landscape, tiny
}
