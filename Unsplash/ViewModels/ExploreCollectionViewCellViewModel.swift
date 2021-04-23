//
//  ExploreCollectionViewCellViewModel.swift
//  Pexels
//
//  Created by Дарья on 06.04.2021.
//

import Foundation

struct ExploreCollectionViewCellViewModel{
    let model: [UnsplashPhotoResponse]
    let index: Int
    
    var photo: UnsplashPhotoResponse {
        return model[index]
    }

}
