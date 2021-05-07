//
//  ExploreCollectionViewCell.swift
//  Pexels
//
//  Created by Дарья on 06.04.2021.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreCollectionViewCell"
    public var representedIdentifier = ""
    
    private var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(photoImageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        authorNameLabel.text = nil
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            authorNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 12),
            authorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            authorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            authorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with photo: UnsplashPhoto) {
        let representedIdentifier = photo.id
        self.representedIdentifier = representedIdentifier
        
        authorNameLabel.text = photo.user.username
        
        if self.representedIdentifier == representedIdentifier {
            guard let url = URL(string: photo.urls.regular) else { return }
            photoImageView.load(url: url)
        }
        setupConstraints()
        contentView.backgroundColor = .clear
    }
}
