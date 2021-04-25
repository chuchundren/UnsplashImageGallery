//
//  SinglePhotoViewController.swift
//  Unsplash
//
//  Created by Дарья on 16.04.2021.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    
    var photoAspectRatio: CGFloat = 1
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var userProfilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 28
        imageView.clipsToBounds = true
        return imageView
    }()
    
     private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        return imageView
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var creationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .lightGray
        button.backgroundColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 6.5, bottom: 15, right: 13.5)
        button.layer.cornerRadius = 36
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    public var photoID: String? {
        didSet {
            fetchSinglePhoto()
        }
    }
    
    private var photo: UnsplashPhoto? {
        didSet {
            DispatchQueue.main.async {
                if self.photo?.likedByUser == true {
                    self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.likeButton.tintColor = .systemPink
                } else {
                    self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.likeButton.tintColor = .lightGray
                }
            }
        }
    }
    
    private var photoViewModel: SinglePhotoViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.setPhoto()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
    
    }
   
    private func setPhoto() {
        guard let viewModel = photoViewModel else {
            return
        }
        photoImageView.load(url: viewModel.photoURL)
        userProfilePhotoImageView.load(url: viewModel.profilePhotoURL)
        usernameLabel.text = viewModel.username
        creationDateLabel.text = viewModel.creationDate
        locationLabel.text = viewModel.location
        descriptionLabel.text = viewModel.photoDescription
        
        setupViews(aspectRatio: CGFloat(viewModel.aspectRatio))
    }
    
    private func setupViews(aspectRatio: CGFloat) {
        view.addSubview(scrollView)
        view.addSubview(likeButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userProfilePhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/aspectRatio),
            
            userProfilePhotoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userProfilePhotoImageView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            userProfilePhotoImageView.widthAnchor.constraint(equalToConstant: 56),
            userProfilePhotoImageView.heightAnchor.constraint(equalToConstant: 56),

            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            usernameLabel.leadingAnchor.constraint(equalTo: userProfilePhotoImageView.trailingAnchor, constant: 8),
            usernameLabel.topAnchor.constraint(equalTo: userProfilePhotoImageView.topAnchor),
            
            locationLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: creationDateLabel.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            
            creationDateLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            creationDateLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: userProfilePhotoImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: userProfilePhotoImageView.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -200),
            
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            likeButton.widthAnchor.constraint(equalToConstant: 72),
            likeButton.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    private func fetchSinglePhoto() {
        guard let id = photoID else { return }
        NetworkManager.shared.getPhoto(id: id) { result in
            switch result {
            case .success(let photo):
                let viewModel = SinglePhotoViewModel(with: photo)
                self.photo = photo
                self.photoViewModel = viewModel
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func likeButtonTapped() {
        guard let id = photoID else { return }
        guard let photo = photo else { return }
        if photo.likedByUser == false {
            NetworkManager.shared.likePhoto(id: id) { result in
                switch result {
                case .success(let result):
                    self.photo = result.photo
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            NetworkManager.shared.unlikePhoto(id: id) { result in
                switch result {
                case .success(let result):
                    self.photo = result.photo
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

