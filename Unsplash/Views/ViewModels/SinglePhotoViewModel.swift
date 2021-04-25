//
//  SinglePhotoViewModel.swift
//  Unsplash
//
//  Created by Дарья on 19.04.2021.
//

import Foundation


struct SinglePhotoViewModel {
    
    private var photo: UnsplashPhoto
    
    init(with photo: UnsplashPhoto) {
        self.photo = photo
    }
    
    public var username: String { photo.user?.username ?? "" }
    
    public var creationDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let date = photo.createdAt
        return dateFormatter.string(from: date)
    }
    
    public var location: String {
        guard let city = photo.location?.city, let country = photo.location?.country else {
            return ""
        }
        return "\(city), \(country)"
    }
    
    public var photoDescription: String { photo.description ?? "" }
    
    public var photoURL: URL? {
        guard let url = URL(string: photo.urls.full) else {
            return nil
        }
        return url
    }
    
    public var profilePhotoURL: URL? {
        guard let url = URL(string: photo.user?.profileImage.small ?? "") else { return nil}
        return url
    }
    
    public var aspectRatio: Float { Float(photo.width) / Float(photo.height) }
    
}
