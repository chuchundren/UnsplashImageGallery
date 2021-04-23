//
//  FeedCollectionViewModel.swift
//  Pexels
//
//  Created by Дарья on 02.04.2021.
//

import Foundation

struct FeedCollectionViewCellViewModel {
    let model: [UnsplashPhotoResponse]
    let index: Int
    
    var photo: UnsplashPhotoResponse {
        return model[index]
    }
    
    var id: String {
        return photo.id
    }
    
    var photoURL: String {
        return photo.urls.regular
    }
    
    var photographer: UnsplashUser {
        return photo.user
    }
    
}
