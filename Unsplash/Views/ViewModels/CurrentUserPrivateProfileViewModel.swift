//
//  CurrentUserPrivateProfileViewModel.swift
//  Unsplash
//
//  Created by Дарья on 23.04.2021.
//

import Foundation


struct CurrentUserPrivateProfileViewModel {
    
    var currentUser: CurrentUserPrivateProfile?
    
    var name: String { "\(currentUser?.firstName ?? "") \(currentUser?.lastName ?? "")" }
    var username: String { "@\(currentUser?.username ?? "")" }
    var bio: String { currentUser?.bio ?? "" }
    var location: String { currentUser?.location ?? "" }
    
}
