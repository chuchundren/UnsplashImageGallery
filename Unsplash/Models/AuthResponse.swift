//
//  AuthResponse.swift
//  Unsplash
//
//  Created by Дарья on 14.04.2021.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let scope: String
    let token_type: String
}
