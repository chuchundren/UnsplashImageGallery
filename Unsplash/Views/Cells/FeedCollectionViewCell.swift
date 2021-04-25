//
//  FeedCollectionViewCell.swift
//  Pexels
//
//  Created by Дарья on 02.04.2021.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeedCollectionViewCell"
    public var representedIdentifier = ""
    
    private var userProfilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 28
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
     var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userProfilePhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(photoImageView)
        setupConstraints()
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        usernameLabel.text = nil
        userProfilePhotoImageView.image = nil
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userProfilePhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userProfilePhotoImageView.trailingAnchor.constraint(equalTo: usernameLabel.leadingAnchor, constant: -8),
            userProfilePhotoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            userProfilePhotoImageView.bottomAnchor.constraint(equalTo: photoImageView.topAnchor, constant: -8),
            userProfilePhotoImageView.widthAnchor.constraint(equalToConstant: 56),
            userProfilePhotoImageView.heightAnchor.constraint(equalToConstant: 56),

            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16)
        ])
    }
    
    func configure(with photo: UnsplashPhoto) {
        let representedIdentifier = photo.id
        self.representedIdentifier = representedIdentifier
        
        usernameLabel.text = photo.user?.username ?? ""
        
        if self.representedIdentifier == representedIdentifier {
            guard let url = URL(string: photo.urls.small) else { return }
            photoImageView.load(url: url)
            
            guard let avatarURL = URL(string: photo.user?.profileImage.small ?? "") else { return }
            userProfilePhotoImageView.load(url: avatarURL)
        }
        
        contentView.backgroundColor = .clear
    }
}
