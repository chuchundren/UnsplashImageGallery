//
//  Extensions.swift
//  Unsplash
//
//  Created by Дарья on 06.04.2021.
//

import UIKit

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            guard let data = try? Data(contentsOf: url) else {
                return }
            guard let image = UIImage(data: data) else {
                return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    func image(from data: Data?) {
        DispatchQueue.main.async {
            if let data = data {
                self.image = UIImage(data: data)
            } else {
                self.image = UIImage(systemName: "photo")
            }
        }
    }
    
}
