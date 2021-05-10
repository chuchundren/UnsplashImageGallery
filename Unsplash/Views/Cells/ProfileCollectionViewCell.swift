//
//  ProfileCollectionViewCell.swift
//  Unsplash
//
//  Created by Дарья on 20.04.2021.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    public var representedIdentifier = ""
    
    public var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with photo: UnsplashPhoto) {
        let representedIdentifier = photo.id
        self.representedIdentifier = representedIdentifier
        
        if self.representedIdentifier == representedIdentifier {
            guard let url = URL(string: photo.urls.small) else { return }
            NetworkManager.shared.downloadAnImage(imageURL: url) { data, error in
                self.imageView.image(from: data)
            }
        }
    }
    
}
